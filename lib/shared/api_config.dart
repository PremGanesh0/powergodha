/// API Configuration for centralized base URL and endpoint management.
///
/// This file provides a centralized location for managing all API configuration
/// including base URL, endpoints, and other API-related constants.
///
/// **Benefits:**
/// * Single source of truth for API configuration
/// * Easy maintenance when endpoints change
/// * Eliminates hardcoded URLs across the codebase
/// * Type-safe configuration management
///
/// **Usage:**
/// ```dart
/// // Get the base URL
/// final baseUrl = ApiConfig.baseUrl;
///
/// // Get full endpoint URL
/// final loginUrl = ApiConfig.getFullUrl(ApiEndpoints.login);
/// ```
library;

/// {@template api_config}
/// Centralized API configuration management.
///
/// This class provides a single source of truth for all API-related
/// configuration including base URL, timeouts, and endpoint paths.
/// It eliminates the need to hardcode URLs in multiple places.
///
/// **Features:**
/// * Centralized base URL management
/// * Default timeout settings
/// * Helper methods for URL construction
/// * Type-safe configuration access
/// {@endtemplate}
class ApiConfig {
  /// Private constructor to prevent instantiation.
  const ApiConfig._();

  /// Base URL for all API requests.
  ///
  /// This is the single source of truth for the API base URL.
  /// Change this value to switch to a different API environment.
  static const String baseUrl = 'https://orb.powergotha.com/api';

  /// Default timeout for API requests in milliseconds.
  static const int defaultTimeoutMs = 30000; // 30 seconds

  /// Default connect timeout in milliseconds.
  static const int defaultConnectTimeoutMs = 10000; // 10 seconds

  /// Default receive timeout in milliseconds.
  static const int defaultReceiveTimeoutMs = 30000; // 30 seconds

  /// Gets the full URL for an endpoint.
  ///
  /// **Parameters:**
  /// * [endpoint] - The endpoint path (e.g., '/auth/login')
  ///
  /// **Returns:**
  /// The complete URL combining base URL and endpoint
  ///
  /// **Example:**
  /// ```dart
  /// final loginUrl = ApiConfig.getFullUrl(ApiEndpoints.login);
  /// // Returns: 'https://dummyjson.com/auth/login'
  /// ```
  static String getFullUrl(String endpoint) {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$base$path';
  }

  /// Creates an update user endpoint with ID substitution.
  ///
  /// **Parameters:**
  /// * [userId] - The user ID to substitute in the endpoint
  ///
  /// **Returns:**
  /// The update endpoint with the user ID substituted

  /// Creates a user-specific endpoint with ID substitution.
  ///
  /// **Parameters:**
  /// * [userId] - The user ID to substitute in the endpoint
  ///
  /// **Returns:**
  /// The endpoint with the user ID substituted
  ///
  /// **Example:**
  /// ```dart
  /// final userEndpoint = ApiConfig.getUserEndpoint('123');
  /// // Returns: '/users/123'
  /// ```
}

/// {@template api_endpoints}
/// Centralized API endpoints configuration.
///
/// This class contains all API endpoints used throughout the application.
/// Having all endpoints in one place makes it easy to maintain and update
/// when the API changes.
///
/// **Categories:**
/// * Authentication endpoints for login, signup, password reset
/// * User management endpoints for profile operations
/// {@endtemplate}
class ApiEndpoints {
  /// Private constructor to prevent instantiation.
  const ApiEndpoints._();

  // User management endpoints
  /// Base users endpoint.
  static const String users = '/users';
}
