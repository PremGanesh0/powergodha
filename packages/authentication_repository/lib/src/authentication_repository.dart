import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_api_client.dart';
import 'models/auth_models.dart';

/// Exception thrown when authentication operations fail.
class AuthenticationException implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// Creates a new authentication exception with the specified message.
  const AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Repository that manages user authentication with dummyjson.com API.
class AuthenticationRepository {
  // Storage keys
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUser = 'user';

  late final Dio _dio;
  late final AuthApiClient _apiClient;
  late final SharedPreferences _prefs;
  late final Logger _logger;

  String? _accessToken;
  String? _refreshToken;
  AuthResponse? _user;
  final _controller = StreamController<AuthenticationStatus>();
  bool _isInitialized = false;
  final _initializationCompleter = Completer<void>();

  /// Creates a new instance of [AuthenticationRepository].
  ///
  /// **Parameters:**
  /// * [dio] - Optional shared HTTP client. If not provided, creates a new one.
  ///   For optimal performance, pass a shared Dio instance.
  /// * [logger] - Optional logger instance. If not provided, creates a default one.
  AuthenticationRepository({Dio? dio, Logger? logger}) {
    _dio = dio ?? Dio(); // Use provided Dio or create a basic one
    _apiClient = AuthApiClient(_dio);
    _logger =
        logger ??
        Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 3,
            lineLength: 80,
            printEmojis: false,
            printTime: true,
          ),
        );
    _initializeStorage();
  }

  /// Get the current access token
  String? get currentAccessToken => _accessToken;

  /// Get the current authenticated user
  AuthResponse? get currentUser => _user;

  /// Stream of authentication status updates.
  Stream<AuthenticationStatus> get status async* {
    // Wait for initialization to complete first
    if (!_isInitialized) {
      // Emit unknown status until initialization is complete
      yield AuthenticationStatus.unknown;
      // Wait for initialization to complete
      await _initializationCompleter.future;
    }

    // After initialization, emit current status immediately
    if (_accessToken != null) {
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }
  /// Disposes resources used by the repository.
  void dispose() {
    _controller.close();
    // Close the Dio client if it has been initialized
    try {
      _dio.close();
    } catch (e) {
      // Ignore errors if _dio wasn't properly initialized
      // This prevents LateInitializationError during app restart
    }
  }

  /// Attempts to log in with the provided credentials.
  ///
  /// Returns [AuthResponse] if successful.
  /// Throws [AuthenticationException] if the login fails.
  Future<AuthResponse> logIn({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final request = LoginRequest(phoneNumber: phoneNumber, password: password, expiresInMins: 30);

      final apiResponse = await _apiClient.login(request);

      // Extract the actual user data from the API response wrapper
      final response = apiResponse.data;

      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      _user = response;

      // Store authentication data
      await Future.wait([
        _prefs.setString(_keyAccessToken, response.accessToken),
        _prefs.setString(_keyRefreshToken, response.refreshToken),
        _prefs.setString(_keyUser, jsonEncode(response.toJson())),
      ]);

      _controller.add(AuthenticationStatus.authenticated);

      _logger.i(
        'User login successful - '
        'user_id: ${response.id}, '
        'phone: ${response.phone}',
      );

      return response;
    } on DioException catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw AuthenticationException(
        (e.response?.data as Map<String, dynamic>)['message']?.toString() ??
            'Authentication failed',
      );
    }
  }

  /// Logs the current user out.
  Future<void> logOut() async {
    _accessToken = null;
    _refreshToken = null;
    _user = null;

    // Clear stored authentication data
    await Future.wait([
      _prefs.remove(_keyAccessToken),
      _prefs.remove(_keyRefreshToken),
      _prefs.remove(_keyUser),
    ]);

    _controller.add(AuthenticationStatus.unauthenticated);
  }

  /// Attempts to refresh the access token using the refresh token.
  ///
  /// Throws [AuthenticationException] if refresh token is not available or refresh fails.
  Future<void> refreshToken() async {
    if (_refreshToken == null) {
      throw const AuthenticationException('No refresh token available');
    }

    try {
      final request = RefreshTokenRequest(refreshToken: _refreshToken!);

      final response = await _apiClient.refreshToken(request);
      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      _user = response;

      // Update stored tokens
      await Future.wait([
        _prefs.setString(_keyAccessToken, response.accessToken),
        _prefs.setString(_keyRefreshToken, response.refreshToken),
        _prefs.setString(_keyUser, jsonEncode(response.toJson())),
      ]);

      _controller.add(AuthenticationStatus.authenticated);
    } on DioException catch (e) {
      // If refresh fails, clear everything and require re-login
      await logOut();
      throw AuthenticationException(
        (e.response?.data as Map<String, dynamic>)['message']?.toString() ?? 'Token refresh failed',
      );
    }
  }

  /// Request a password reset for the given email address.
  ///
  /// Throws [AuthenticationException] if the request fails.
  Future<void> requestPasswordReset(String email) async {
    try {
      await _apiClient.requestPasswordReset(email);
    } on DioException catch (e) {
      throw AuthenticationException(
        e.response?.data?['message']?.toString() ?? 'Failed to send password reset email',
      );
    } catch (e) {
      throw const AuthenticationException('An unexpected error occurred');
    }
  }

  /// Signs up a new user and returns registration response with OTP.
  ///
  /// This method registers a new user and returns the OTP information
  /// that needs to be verified before the user can log in.
  ///
  /// **Parameters:**
  /// * [name] - User's full name
  /// * [phoneNumber] - User's phone number
  /// * [password] - User's password
  ///
  /// **Returns:** [RegistrationResponse] containing OTP and user information
  /// **Throws:** [AuthenticationException] if signup fails
  Future<RegistrationResponse> signUp({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final request = SignupRequest(
        name: name, phoneNumber: phoneNumber,
        password: password,
      );

      final apiResponse = await _apiClient.signup(request);

      if (apiResponse.status == 200) {
        _logger.i(
          'User registration successful - '
          'user_id: ${apiResponse.data.userId}, '
          'phone_number: ${apiResponse.data.phoneNumber}',
        );

        return apiResponse.data;
      } else {
        throw AuthenticationException(apiResponse.message);
      }
    } on DioException catch (e) {
      _logger.e('Registration failed', error: e);
      throw AuthenticationException(
        e.response?.data?['message']?.toString() ?? 'Failed to sign up',
      );
    } catch (e) {
      _logger.e('Unexpected registration error', error: e);
      throw const AuthenticationException('An unexpected error occurred during registration');
    }
  }

  /// Verifies OTP for user registration and completes the authentication.
  ///
  /// This method verifies the OTP received during registration and
  /// authenticates the user if verification is successful.
  ///
  /// **Parameters:**
  /// * [phoneNumber] - User's phone number
  /// * [otp] - OTP code received via SMS
  /// * [userId] - User ID from registration response
  ///
  /// **Returns:** [AuthResponse] with authentication tokens
  /// **Throws:** [AuthenticationException] if verification fails
  Future<OtpVerificationResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
    required int userId,
  }) async {
    try {
      final response = await _apiClient.verifyOtp(userId.toString(), otp);

      if (response.status == 200) {
        _logger.i(
          'OTP verification successful - '
          'user_id: $userId, '
          'phone: $phoneNumber, '
          'message: ${response.message}',
        );

        // OTP verified successfully - user registration is now complete
        // For this API, OTP verification doesn't return auth tokens
        // The user will need to log in separately after OTP verification
        return response;
      } else {
        throw AuthenticationException(response.message);
      }
    } on DioException catch (e) {
      _logger.e('OTP verification failed', error: e);
      throw AuthenticationException(
        e.response?.data?['message']?.toString() ?? 'OTP verification failed',
      );
    } catch (e) {
      if (e is AuthenticationException) {
        rethrow;
      }
      _logger.e('Unexpected OTP verification error', error: e);
      throw const AuthenticationException('An unexpected error occurred during OTP verification');
    }
  }

  /// Initialize persistent storage and restore previous session if available
  Future<void> _initializeStorage() async {
    _logger.i('AuthenticationRepository: Starting initialization...');
    _prefs = await SharedPreferences.getInstance();
    // Restore tokens
    _accessToken = _prefs.getString(_keyAccessToken);
    _refreshToken = _prefs.getString(_keyRefreshToken);

    // Restore user data if available
    final userJson = _prefs.getString(_keyUser);
    if (userJson != null) {
      _user = AuthResponse.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    }

    // Mark initialization as complete
    _isInitialized = true;
    _initializationCompleter.complete();

    // Update initial status
    if (_accessToken != null) {
      _logger.i('AuthenticationRepository: User is authenticated');
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _logger.i('AuthenticationRepository: User is not authenticated');
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }
}

enum AuthenticationStatus { unknown, authenticated, unauthenticated }
