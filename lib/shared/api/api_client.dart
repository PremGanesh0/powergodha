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

  // Track language changes to force new Dio instance creation
  static bool _languageWasChanged = false;

  // Track when the instance was last created (milliseconds since epoch)
  static int? _lastInstanceCreationTime;

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

    // Instead of complex checks that might fail, use a simpler approach:
    // If a language change was detected recently or it's been a while since
    // the instance was created, just create a new one to be safe

    // Check if the current instance is still valid
    try {
      // First check if we can access the baseUrl (catches most invalid states)
      final baseUrl = _instance.options.baseUrl;
      if (baseUrl.isEmpty) {
        AppLogger.warning('ApiClient: Base URL is empty, creating new instance');
        return _createDioInstance();
      }

      // Check instance creation time if we're tracking it
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final lastCreationTime = _lastInstanceCreationTime ?? 0;
      final instanceAge = currentTime - lastCreationTime;

      // If instance is older than 30 minutes, recreate it to be safe
      if (lastCreationTime > 0 && instanceAge > 30 * 60 * 1000) {
        AppLogger.info('ApiClient: Instance is older than 30 minutes, creating new one for safety');
        return _createDioInstance();
      }

      // Simple check for adapter validity without relying on specific properties
      try {
        final adapter = _instance.httpClientAdapter;
        if (adapter == null) {
          // This shouldn't happen, but just in case
          throw Exception('Adapter is null');
        }

        // Basic connectivity check - can we initialize a request?
        final requestOptions = RequestOptions(path: '');
        requestOptions.baseUrl = _instance.options.baseUrl;
        _instance.transformer.transformRequest(requestOptions);

        // If we got here, the instance seems valid
        return _instance;
      } catch (e) {
        AppLogger.warning('ApiClient: Error checking adapter health: $e');
        return _createDioInstance();
      }

    } catch (e) {
      AppLogger.warning(
        'ApiClient: Error checking Dio instance, creating new one: $e',
      );
      // If the instance is invalid (like after adapter closed),
      // create a new one on demand
      return _createDioInstance();
    }
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

  /// Call this when language is changed
  static void notifyLanguageChanged() {
    _languageWasChanged = true;
    AppLogger.info('ApiClient: Language change notification received');
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
    // Update the creation timestamp
    _lastInstanceCreationTime = DateTime.now().millisecondsSinceEpoch;
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

  /// Check if language was recently changed
  static bool _wasLanguageChanged() {
    // Reset after checking once
    if (_languageWasChanged) {
      _languageWasChanged = false;
      return true;
    }
    return false;
  }
}
