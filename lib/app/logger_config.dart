/// Global logger configuration for the PowerGodha application.
///
/// This file provides a centralized logging configuration that can be used
/// throughout the entire application. It includes:
/// * Different log levels for development and production
/// * Custom formatting for better readability
/// * File logging capabilities for production builds
/// * Network request/response logging
/// * Error tracking and reporting
///
/// **Usage:**
/// ```dart
/// import 'package:powergodha/shared/logger_config.dart';
///
/// // Use the global logger
/// AppLogger.info('User logged in successfully');
/// AppLogger.error('Failed to fetch data', error: exception);
/// AppLogger.debug('Debug information');
/// ```
///
/// **Log Levels:**
/// * TRACE - Most detailed logging
/// * DEBUG - Debug information (development only)
/// * INFO - General information
/// * WARNING - Warning messages
/// * ERROR - Error messages
/// * FATAL - Fatal errors
library;

import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// {@template app_logger}
/// A centralized logger configuration for the PowerGodha application.
///
/// This class provides static methods for logging at different levels
/// and handles configuration for both development and production environments.
///
/// **Features:**
/// * Environment-specific configuration
/// * File logging in production
/// * Console logging in development
/// * Custom formatting for better readability
/// * Integration with Flutter's developer tools
///
/// **Log Levels Available:**
/// * [trace] - Most detailed logging (development only)
/// * [debug] - Debug information (development only)
/// * [info] - General information
/// * [warning] - Warning messages
/// * [error] - Error messages and exceptions
/// * [fatal] - Fatal errors that may crash the app
/// {@endtemplate}
class AppLogger {
  /// Private constructor to prevent instantiation
  AppLogger._();

  /// The main logger instance used throughout the app
  static Logger? _logger;

  /// Whether the logger has been initialized
  static bool _isInitialized = false;

  /// Get the logger instance for use in external packages
  ///
  /// This allows packages to access the global logger instance without
  /// having to import the entire AppLogger configuration.
  static Logger get instance => _instance;

  /// Get the logger instance, initializing it if necessary
  static Logger get _instance {
    if (!_isInitialized) {
      developer.log('Logger not initialized, using default configuration', name: 'AppLogger');
      _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
        ),
      );
      _isInitialized = true;
    }
    return _logger!;
  }

  /// Clear log files (useful for maintenance)
  static Future<void> clearLogs() async {
    try {
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        final logFile = File('${directory.path}/app_logs.txt');
        if (await logFile.exists()) {
          await logFile.delete();
          info('Log files cleared successfully');
        }
      }
    } catch (e) {
      error('Failed to clear log files', error: e);
    }
  }

  /// Log a debug message
  ///
  /// Use for information that is diagnostically helpful to developers.
  /// Only shown in debug builds by default.
  ///
  /// **Parameters:**
  /// * [message] - The message to log
  /// * [error] - Optional error object
  /// * [stackTrace] - Optional stack trace
  /// * [data] - Optional additional data
  static void debug(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _instance.d(
      _formatMessage(message, data),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an error message
  ///
  /// Use for error events that don't cause the app to crash
  /// but indicate something went wrong.
  ///
  /// **Parameters:**
  /// * [message] - The message to log
  /// * [error] - Optional error object
  /// * [stackTrace] - Optional stack trace
  /// * [data] - Optional additional data
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _instance.e(
      _formatMessage(message, data),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a fatal error message
  ///
  /// Use for very severe error events that may cause the app to crash.
  ///
  /// **Parameters:**
  /// * [message] - The message to log
  /// * [error] - Optional error object
  /// * [stackTrace] - Optional stack trace
  /// * [data] - Optional additional data
  static void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _instance.f(
      _formatMessage(message, data),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Get log file path (for sharing or debugging)
  static Future<String?> getLogFilePath() async {
    try {
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        final logFile = File('${directory.path}/app_logs.txt');
        if (await logFile.exists()) {
          return logFile.path;
        }
      }
      return null;
    } catch (e) {
      error('Failed to get log file path', error: e);
      return null;
    }
  }

  /// Log an info message
  ///
  /// Use for general information about app operation.
  /// These messages are shown in all builds.
  ///
  /// **Parameters:**
  /// * [message] - The message to log
  /// * [data] - Optional additional data
  static void info(
    String message, {
    Map<String, dynamic>? data,
  }) {
    _instance.i(_formatMessage(message, data));
  }

  /// Initialize the logger with appropriate configuration
  ///
  /// This method should be called once during app startup, preferably
  /// in the main() function before runApp().
  ///
  /// **Parameters:**
  /// * [enableFileLogging] - Whether to enable file logging (default: production mode)
  /// * [logLevel] - Minimum log level to display (default: Level.debug in debug mode, Level.info in release mode)
  ///
  /// **Example:**
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await AppLogger.initialize();
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> initialize({
    bool? enableFileLogging,
    Level? logLevel,
  }) async {
    if (_isInitialized) {
      return;
    }

    // Determine default values based on build mode
    const isDebugMode = kDebugMode;
    final shouldLogToFile = enableFileLogging ?? !isDebugMode;
    final defaultLogLevel = logLevel ?? (isDebugMode ? Level.debug : Level.info);

    LogOutput output;

    if (shouldLogToFile && !kIsWeb) {
      // For production, log to both console and file
      try {
        final directory = await getApplicationDocumentsDirectory();
        final logFile = File('${directory.path}/app_logs.txt');

        output = MultiOutput([
          ConsoleOutput(),
          FileOutput(file: logFile),
        ]);
      } catch (e) {
        // If file logging fails, fall back to console only
        output = ConsoleOutput();
        developer.log('Failed to setup file logging: $e', name: 'AppLogger');
      }
    } else {
      // For development or web, use console only
      output = ConsoleOutput();
    }

    _logger = Logger(
      filter: ProductionFilter(), // Only log in debug mode or if explicitly enabled
      printer: PrettyPrinter(
        printTime: true, // Include timestamp
      ),
      output: output,
      level: defaultLogLevel,
    );

    _isInitialized = true;

    // Log successful initialization
    info('Logger initialized successfully', data: {
      'debug_mode': isDebugMode,
      'file_logging': shouldLogToFile,
      'log_level': defaultLogLevel.name,
    });
  }

  /// Log a trace message (most detailed level)
  ///
  /// Use for very detailed information that is typically only of interest
  /// when diagnosing problems.
  ///
  /// **Parameters:**
  /// * [message] - The message to log
  /// * [error] - Optional error object
  /// * [stackTrace] - Optional stack trace
  /// * [data] - Optional additional data
  static void trace(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _instance.t(
      _formatMessage(message, data),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a warning message
  ///
  /// Use for potentially harmful situations that don't prevent
  /// the app from continuing to work.
  ///
  /// **Parameters:**
  /// * [message] - The message to log
  /// * [error] - Optional error object
  /// * [data] - Optional additional data
  static void warning(
    String message, {
    Object? error,
    Map<String, dynamic>? data,
  }) {
    _instance.w(
      _formatMessage(message, data),
      error: error,
    );
  }

  /// Format a log message with optional data
  static String _formatMessage(String message, Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return message;
    }

    final dataString = data.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', ');

    return '$message | $dataString';
  }
}


