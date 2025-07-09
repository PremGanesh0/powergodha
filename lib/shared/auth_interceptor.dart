/// Authentication Interceptor for API requests.
///
/// This interceptor automatically adds authentication headers to API requests
/// and handles token refresh when needed.
library;

import 'package:dio/dio.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template auth_interceptor}
/// Dio interceptor that handles authentication for API requests.
///
/// This interceptor:
/// * Automatically adds Bearer tokens to requests
/// * Handles token refresh when tokens expire
/// * Manages authentication state
/// * Redirects to login when authentication Fails(),
/// {@endtemplate}
class AuthInterceptor extends Interceptor {
  /// Creates an [AuthInterceptor].
  AuthInterceptor();

  /// Storage key for access token.
  static const String _accessTokenKey = 'access_token';

  /// Storage key for refresh token.
  static const String _refreshTokenKey = 'refresh_token';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      AppLogger.info('Received 401 Unauthorized, attempting token refresh');

      try {
        final refreshed = await _refreshToken();

        if (refreshed) {
          // Retry the original request with new token
          final retryResponse = await _retryRequest(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        } else {
          // Refresh failed, clear tokens and redirect to login
          await _clearTokens();
          AppLogger.warning('Token refresh failed, user needs to re-authenticate');
        }
      } catch (e) {
        AppLogger.error('Token refresh error', error: e);
        await _clearTokens();
      }
    }

    handler.next(err);
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip authentication for login, signup, and public endpoints
    if (_isPublicEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    try {
      final accessToken = await _getAccessToken();

      if (accessToken != null) {
        // Add Authorization header
        options.headers['Authorization'] = 'Bearer $accessToken';

        AppLogger.debug(
          'Added Authorization header',
          data: {'endpoint': options.path},
        );
      } else {
        AppLogger.warning(
          'No access token available for authenticated endpoint',
          data: {'endpoint': options.path},
        );
      }
    } catch (e) {
      AppLogger.error(
        'Failed to add authentication header',
        error: e,
        data: {'endpoint': options.path},
      );
    }

    handler.next(options);
  }

  /// Stores the access and refresh tokens.
  Future<void> storeTokens({required String accessToken, required String refreshToken}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, accessToken);
      await prefs.setString(_refreshTokenKey, refreshToken);

      AppLogger.info('Tokens stored successfully');
    } catch (e) {
      AppLogger.error('Failed to store tokens', error: e);
    }
  }

  /// Clears all stored tokens.
  Future<void> _clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);

      AppLogger.info('Tokens cleared');
    } catch (e) {
      AppLogger.error('Failed to clear tokens', error: e);
    }
  }

  /// Gets the stored access token.
  Future<String?> _getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (e) {
      AppLogger.error('Failed to get access token', error: e);
      return null;
    }
  }

  /// Gets the stored refresh token.
  Future<String?> _getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      AppLogger.error('Failed to get refresh token', error: e);
      return null;
    }
  }

  /// Checks if the endpoint is public (doesn't require authentication).
  bool _isPublicEndpoint(String path) {
    final publicPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/refresh',
    ];

    return publicPaths.any((publicPath) => path.contains(publicPath));
  }

  /// Attempts to refresh the access token.
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _getRefreshToken();

      if (refreshToken == null) {
        AppLogger.warning('No refresh token available');
        return false;
      }

      // Create a new Dio instance to avoid interceptor loops
      final dio = Dio();

      final response = await dio.post<Map<String, dynamic>>(
        'https://orb.powergotha.com/api/auth/refresh', // Use your base URL
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data != null && data['success'] == true && data['data'] != null) {
          final tokenData = data['data'] as Map<String, dynamic>;
          final newAccessToken = tokenData['access_token'] as String?;
          final newRefreshToken = tokenData['refresh_token'] as String?;

          if (newAccessToken != null && newRefreshToken != null) {
            await storeTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            AppLogger.info('Token refresh successful');
            return true;
          }
        }
      }

      AppLogger.warning('Token refresh failed: Invalid response');
      return false;
    } catch (e) {
      AppLogger.error('Token refresh error', error: e);
      return false;
    }
  }

  /// Retries the original request with the new access token.
  Future<Response<dynamic>> _retryRequest(RequestOptions options) async {
    try {
      final accessToken = await _getAccessToken();

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      // Create a fresh Dio instance to avoid interceptor loops and closed adapter issues
      final dio = Dio(
        BaseOptions(
          baseUrl: options.baseUrl,
          connectTimeout: const Duration(milliseconds: 30000),
          receiveTimeout: const Duration(milliseconds: 30000),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        ),
      );

      AppLogger.debug('Retrying request with fresh Dio instance: ${options.path}');
      return await dio.fetch(options);
    } catch (e) {
      AppLogger.error('Failed to retry request', error: e);
      rethrow;
    }
  }

  /// Checks if there are valid tokens in storage, regardless of authentication status.
  /// This is useful after app restart or language changes to determine if we should
  /// try to preserve authentication state despite possible network errors.
  static Future<bool> hasTokensInStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(_accessTokenKey);
      final refreshToken = prefs.getString(_refreshTokenKey);

      final hasValidTokens =
          accessToken != null &&
          accessToken.isNotEmpty &&
          refreshToken != null &&
          refreshToken.isNotEmpty;

      AppLogger.info('AuthInterceptor: Token check - has valid tokens: $hasValidTokens');
      return hasValidTokens;
    } catch (e) {
      AppLogger.error('AuthInterceptor: Error checking token storage', error: e);
      return false;
    }
  }

  /// Checks if the user is currently authenticated.
  static Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(_accessTokenKey);
      return accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      AppLogger.error('Failed to check authentication status', error: e);
      return false;
    }
  }

  /// Clears tokens and logs out the user.
  /// This method can be called from the UI when user manually logs out.
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);

      AppLogger.info('User logged out, tokens cleared');
    } catch (e) {
      AppLogger.error('Failed to logout', error: e);
    }
  }
}
