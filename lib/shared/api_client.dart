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
import 'package:powergodha/app/logging_interceptor.dart';
import 'package:powergodha/shared/api_config.dart';

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
  static Dio get instance => _instance;

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
        connectTimeout: connectTimeout ?? const Duration(milliseconds: ApiConfig.defaultConnectTimeoutMs),
        receiveTimeout: receiveTimeout ?? const Duration(milliseconds: ApiConfig.defaultReceiveTimeoutMs),
        headers: defaultHeaders,
        followRedirects: true,
        maxRedirects: 3,
      ),
    );

    // Add the same interceptors as the shared instance
    dio.interceptors.addAll([
      LoggingInterceptor(),
    ]);

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
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.defaultConnectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: ApiConfig.defaultReceiveTimeoutMs),
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
    dio.interceptors.addAll([
      LoggingInterceptor(),
      // Add more interceptors here as needed
      // Example: AuthInterceptor(), ErrorInterceptor(), etc.
    ]);

    return dio;
  }
}
