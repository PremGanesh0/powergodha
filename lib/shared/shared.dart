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

// Logging
export '../app/app_logger_config.dart';
// API and networking
export 'api/api_client.dart';
export 'api/api_config.dart';
export 'api/api_endpoints.dart';
export 'api/api_models.dart';
// Localization and strings
export 'app_strings.dart';
export 'auth_interceptor.dart';
export 'localization_service.dart';
export 'retrofit/retrofit_client.dart';
export 'services/about_app_data_service.dart';
export 'services/notification_count_service.dart';
export 'services/slider_articles_service.dart';
// Services
export 'services/user_language_service.dart';
// Theme and styling
export 'theme.dart';
export 'theme_extensions.dart';
// Widgets
export 'widgets/app_notification_button.dart';
