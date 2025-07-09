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


}
