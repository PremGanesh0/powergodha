/// Export all the files in the shared directory to use in other packages.
///
/// This barrel file provides a single import point for all shared utilities,
/// configurations, and services used throughout the PowerGodha application.
///
/// **Usage:**
/// ```dart
/// import 'package:powergodha/shared/shared.dart';
///
/// // Now you can use any shared utility:
/// AppLogger.info('Message');
/// final client = ApiClient();
/// final theme = AppTheme.lightTheme;
/// ```
library shared;

// API and networking
export 'api_client.dart';
export 'api_config.dart';
// Localization and strings
export 'app_strings.dart';
export 'localization_service.dart';
// Logging
export '../app/logger_config.dart';
// Theme and styling
export 'theme.dart';
export 'theme_extensions.dart';
