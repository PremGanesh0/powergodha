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

  // Using private Dio field - will be updated as needed with getValidDioClient()
  late Dio _dio;
  // ApiClient is not final so it can be recreated as needed
  late SharedPreferences _prefs;
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
    try {
      // Try to ensure we have a valid Dio client, but don't try to update _apiClient
      getValidDioClient();
    } catch (e) {
      // Log the error but continue - authentication status doesn't depend on API client
      _logger.e('Error refreshing Dio client during status check: ${e.toString()}');
    }

    // Wait for initialization to complete first
    if (!_isInitialized) {
      _logger.i('Authentication status requested, initialization not complete yet');
      // Emit unknown status until initialization is complete
      yield AuthenticationStatus.unknown;
      // Wait for initialization to complete
      await _initializationCompleter.future;
      _logger.i('Initialization completed, proceeding with authentication status');
    }

    // Force a check of the access token in shared preferences
    // This helps ensure we have the latest token after app restart
    try {
      // Only re-check if we're already initialized (prevents recursion)
      if (_isInitialized) {
        _logger.i('Double-checking token from storage after initialization');
        final prefs = await SharedPreferences.getInstance();
        final storedToken = prefs.getString(_keyAccessToken);

        // Update our in-memory token if it doesn't match what's in storage
        if (_accessToken != storedToken) {
          _logger.i('Token mismatch detected during status check, updating');
          _accessToken = storedToken;
        }
      }
    } catch (e) {
      _logger.e('Error checking token during status request', error: e);
      // Continue with what we have, don't change authentication status due to an error
    }

    // After initialization, emit current status immediately based on token
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      _logger.i('Emitting authenticated status, token exists');
      yield AuthenticationStatus.authenticated;
    } else {
      _logger.i('Emitting unauthenticated status, no token found');
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  /// Gets a valid API client using the current Dio instance
  ///
  /// This ensures we always use the most up-to-date Dio instance
  /// which is especially important after app restarts or language changes.
  AuthApiClient get _apiClient => AuthApiClient(getValidDioClient());

  /// Disposes resources used by the repository.
  void dispose() {
    _controller.close();
    // We don't close the Dio client anymore as it might be needed after app restart
    // Closing it leads to "Can't establish connection after the adapter was closed" errors
    // The Dio instance will be garbage collected when no longer needed
  }

  /// Gets a valid Dio client, creating a new one if the current one is closed
  ///
  /// This is especially important after app restart or language change
  /// when the Dio instance might have been closed.
  ///
  /// When a new Dio instance is created, we update our reference.
  /// The _apiClient getter will always use this latest Dio instance.
  Dio getValidDioClient() {
    try {
      // Test if the current Dio instance is valid by checking if it's closed
      bool isClosed = false;
      try {
        isClosed = (_dio.httpClientAdapter as dynamic).closed == true;
      } catch (e) {
        // If we can't check this property, assume it's not closed
        _logger.w("Could not check if Dio adapter is closed, assuming it's valid", error: e);
      }

      if (isClosed) {
        _logger.w('Dio client detected as closed, creating a new one');
        // Create a new Dio instance
        final newDio = Dio();

        // Copy over any configurations from the old Dio if possible
        try {
          newDio.options = _dio.options;
        } catch (e) {
          _logger.w('Could not copy Dio options, using defaults', error: e);
          // Configure with some reasonable defaults
          newDio.options = BaseOptions(
            connectTimeout: const Duration(milliseconds: 30000),
            receiveTimeout: const Duration(milliseconds: 30000),
            sendTimeout: const Duration(milliseconds: 30000),
          );
        }

        // Update our reference to the Dio instance
        _dio = newDio;

        _logger.i('Successfully created new Dio instance');
      }
    } catch (e) {
      _logger.e('Error checking Dio client status: ${e.toString()}');
      // Don't try to create a new instance here to avoid potential errors
    }

    // Always return the current Dio instance
    return _dio;
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
      // Ensure we have a valid Dio client before making the API call
      getValidDioClient();
      _logger.i('Attempting login with phone: $phoneNumber');

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
      // Ensure we have a valid Dio client before making the API call
      getValidDioClient();
      _logger.i('Attempting to refresh token');

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
      // Ensure we have a valid Dio client before making the API call
      getValidDioClient();
      _logger.i('Attempting password reset for: $email');

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
      // Ensure we have a valid Dio client before making the API call
      getValidDioClient();
      _logger.i('Attempting signup for: $name, phone: $phoneNumber');

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
      // Ensure we have a valid Dio client before making the API call
      getValidDioClient();
      _logger.i('Attempting to verify OTP for user ID: $userId');

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
        (e.response?.data as Map<String, dynamic>)['message']?.toString() ?? 'OTP verification failed',
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
    try {
      _prefs = await SharedPreferences.getInstance();

      // Restore tokens with detailed logging
      _accessToken = _prefs.getString(_keyAccessToken);
      _refreshToken = _prefs.getString(_keyRefreshToken);

      _logger.i(
        'AuthenticationRepository: Access token loaded: ${_accessToken != null ? "Yes" : "No"}',
      );
      _logger.i(
        'AuthenticationRepository: Refresh token loaded: ${_refreshToken != null ? "Yes" : "No"}',
      );

      // Restore user data if available
      final userJson = _prefs.getString(_keyUser);
      if (userJson != null) {
        try {
          _user = AuthResponse.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
          _logger.i('AuthenticationRepository: User data loaded successfully (ID: ${_user?.id})');
        } catch (e) {
          _logger.e('AuthenticationRepository: Error parsing user data', error: e);
          _user = null;
        }
      } else {
        _logger.i('AuthenticationRepository: No user data found in storage');
      }

      // Update initial status based on tokens - critical for language change restart
      final hasValidAuth = _accessToken != null && _accessToken!.isNotEmpty;

      if (hasValidAuth) {
        _logger.i(
          'AuthenticationRepository: Valid authentication found, setting authenticated status',
        );
        _controller.add(AuthenticationStatus.authenticated);
      } else {
        _logger.i(
          'AuthenticationRepository: No valid authentication found, setting unauthenticated status',
        );
        _controller.add(AuthenticationStatus.unauthenticated);
      }
    } catch (e) {
      _logger.e('AuthenticationRepository: Error during initialization', error: e);

      // On initialization error:
      // 1. Check if we might have had tokens before (this could be a network error after language change)
      // 2. Only default to unauthenticated if we're certain there are no tokens

      try {
        final prefs = await SharedPreferences.getInstance();
        final storedToken = prefs.getString(_keyAccessToken);

        if (storedToken != null && storedToken.isNotEmpty) {
          // We have a token despite the error, so preserve authenticated status
          _logger.i('AuthenticationRepository: Found valid token despite initialization error');
          _accessToken = storedToken;
          _controller.add(AuthenticationStatus.authenticated);
        } else {
          // No token found, truly unauthenticated
          _logger.i(
            'AuthenticationRepository: No valid token found after error, setting unauthenticated',
          );
          _controller.add(AuthenticationStatus.unauthenticated);
        }
      } catch (secondError) {
        // If checking again fails, default to unauthenticated
        _logger.e(
          'AuthenticationRepository: Failed to check tokens after error',
          error: secondError,
        );
        _controller.add(AuthenticationStatus.unauthenticated);
      }
    } finally {
      // Mark initialization as complete in all cases
      _isInitialized = true;
      _initializationCompleter.complete();
    }
  }
}

enum AuthenticationStatus { unknown, authenticated, unauthenticated }
