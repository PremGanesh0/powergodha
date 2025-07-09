/// Centralized HTTP client configuration for the entire application.
///
/// This file provides a shared [Dio] instance with common configuration
/// including base URL, timeouts, interceptors, and headers. All repositories
/// should use this shared client for optimal performance and consistency.
///
/// **Benefits:**
/// * Single HTTP client instance reduces memory footprint
/// * Shared connection pool improves performance
/// * Centralized configuration and interceptors
/// * Consistent error handling across the app
///
/// **Usage:**
/// ```dart
/// // Get the shared client instance
/// final dio = ApiClient.instance;
///
/// // Use in repositories
/// AuthenticationRepository(dio: ApiClient.instance);
/// ```
library;

import 'package:dio/dio.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/app/logging_interceptor.dart';
import 'package:powergodha/shared/api/api_config.dart';
import 'package:powergodha/shared/auth_interceptor.dart';

/// {@template api_client}
/// Centralized HTTP client for all API communications.
///
/// This class provides a single, pre-configured [Dio] instance that should
/// be used by all repositories and API clients. It includes:
///
/// **Configuration:**
/// * Base URL from [ApiConfig]
/// * Default timeouts and headers
/// * Common interceptors (logging, error handling)
/// * Connection pooling for optimal performance
///
/// **Interceptors included:**
/// * [LoggingInterceptor] - Logs all HTTP requests and responses
/// * Additional interceptors can be added as needed
/// {@endtemplate}
class ApiClient {
  /// Private constructor to prevent instantiation.
  const ApiClient._();

  /// Shared [Dio] instance for all API communications.
  ///
  /// This static instance ensures optimal performance by:
  /// * Reusing connection pools across all HTTP requests
  /// * Sharing interceptors and configuration
  /// * Reducing memory footprint
  /// * Avoiding multiple client creation overhead
  ///
  /// **Configuration:**
  /// * Base URL: [ApiConfig.baseUrl]
  /// * Connect timeout: [ApiConfig.defaultConnectTimeoutMs]
  /// * Receive timeout: [ApiConfig.defaultReceiveTimeoutMs]
  /// * Default headers for JSON communication
  static final Dio _instance = _createDioInstance();

  /// Gets the shared [Dio] instance.
  ///
  /// All repositories and API clients should use this instance
  /// instead of creating their own [Dio] instances.
  ///
  /// After language changes, this will always return a fresh Dio instance
  /// to avoid "closed adapter" errors.
  static Dio get instance {
    // ALWAYS create a new instance after language changes
    // This is more reliable than trying to check the adapter status
    if (_wasLanguageChanged()) {
      AppLogger.info(
        'ApiClient: Language change detected, creating brand new instance',
      );
      return _createDioInstance();
    }

    // Otherwise check if the existing instance is valid
    try {
      // First check if we can access the baseUrl (catches most invalid states)
      _instance.options.baseUrl;

      // Also check if the adapter is closed (specific check for language change issues)
      var isClosed = false;
      try {
        isClosed = (_instance.httpClientAdapter as dynamic).closed == true;
      } catch (e) {
        // If we can't check this property, assume it's still valid
      }

      if (isClosed) {
        AppLogger.info(
          'ApiClient: Dio adapter was closed, creating new instance',
        );
        return _createDioInstance();
      }

      return _instance;
    } catch (e) {
      AppLogger.warning(
        'ApiClient: Error checking Dio instance, creating new one: $e',
      );
      // If the instance is invalid (like after adapter closed),
      // create a new one on demand
      return _createDioInstance();
    }
  }

  // Track language changes to force new Dio instance creation
  static bool _languageWasChanged = false;

  /// Check if language was recently changed
  static bool _wasLanguageChanged() {
    // Reset after checking once
    if (_languageWasChanged) {
      _languageWasChanged = false;
      return true;
    }
    return false;
  }

  /// Call this when language is changed
  static void notifyLanguageChanged() {
    _languageWasChanged = true;
    AppLogger.info('ApiClient: Language change notification received');
  }

  /// Creates a new [Dio] instance with custom configuration.
  ///
  /// Use this method only when you need a client with different
  /// configuration than the shared instance. In most cases,
  /// you should use [instance] instead.
  ///
  /// **Parameters:**
  /// * [baseUrl] - Custom base URL (defaults to [ApiConfig.baseUrl])
  /// * [connectTimeout] - Custom connect timeout
  /// * [receiveTimeout] - Custom receive timeout
  /// * [headers] - Additional headers to merge with defaults
  ///
  /// **Returns:**
  /// A new [Dio] instance with the specified configuration.
  static Dio createCustomInstance({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, String>? headers,
  }) {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConfig.baseUrl,
        connectTimeout:
            connectTimeout ??
            const Duration(milliseconds: ApiConfig.defaultConnectTimeoutMs),
        receiveTimeout:
            receiveTimeout ??
            const Duration(milliseconds: ApiConfig.defaultReceiveTimeoutMs),
        headers: defaultHeaders,
        followRedirects: true,
        maxRedirects: 3,
      ),
    );

    // Add the same interceptors as the shared instance
    dio.interceptors.addAll([AuthInterceptor(), const LoggingInterceptor()]);

    return dio;
  }

  /// Creates and configures the [Dio] instance.
  ///
  /// This method sets up the base configuration including:
  /// * Base URL from centralized configuration
  /// * Timeout settings
  /// * Default headers
  /// * Interceptors for logging and error handling
  static Dio _createDioInstance() {
    AppLogger.info('ApiClient: Creating new Dio instance');
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConfig.defaultConnectTimeoutMs,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConfig.defaultReceiveTimeoutMs,
        ),
        sendTimeout: const Duration(milliseconds: ApiConfig.defaultTimeoutMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        followRedirects: true,
        maxRedirects: 3,
      ),
    );

    // Add interceptors
    try {
      dio.interceptors.addAll([
        AuthInterceptor(),
        const LoggingInterceptor(),
        // Add more interceptors here as needed
      ]);
      AppLogger.info('ApiClient: Added interceptors to new Dio instance');
    } catch (e) {
      AppLogger.error('ApiClient: Error adding interceptors: $e');
      // Continue without interceptors if there was an error
    }

    // We can't directly update the static instance because it's final,
    // but the getter will handle creating a new instance when needed

    return dio;
  }
}
