/// App restarting utility to handle locale changes.
///
/// This utility widget helps with restarting the app after language changes
/// by recreating the app with a new locale, ensuring that all widgets
/// rebuild with the correct language settings.
library;

import 'package:flutter/material.dart';
import 'package:powergodha/app/app.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/shared/api/api_client.dart';

/// {@template app_restarter}
/// A utility widget that restarts the app with a new locale.
///
/// This widget helps solve the common issue with Flutter apps where changing
/// the locale doesn't immediately update all the UI. By recreating the app
/// from the root with the new locale, we ensure that all widgets rebuild
/// with the correct language settings.
///
/// **Usage:**
/// ```dart
/// // Force the app to restart with a new locale
/// runApp(AppRestarter(locale: Locale('hi')));
///
/// // Force the app to restart with a new locale and navigate to login
/// runApp(AppRestarter(locale: Locale('hi'), initialRoute: AppRoutes.login));
/// ```
///
/// This approach is more reliable than setting the locale on the existing
/// MaterialApp instance, as it ensures that all widgets rebuild from scratch
/// with the new locale.
/// {@endtemplate}
class AppRestarter extends StatelessWidget {
  /// {@macro app_restarter}
  const AppRestarter({
    required this.locale,
    this.initialRoute,
    super.key,
  });

  /// The new locale to apply when restarting the app
  final Locale locale;

  /// Optional initial route to navigate to after restart
  final String? initialRoute;

  @override
  Widget build(BuildContext context) {
    // Log restart information
    AppLogger.info('AppRestarter: Restarting app with locale: ${locale.languageCode}${initialRoute != null ? ', route: $initialRoute' : ''}');

    // Make sure ApiClient knows about the language change
    ApiClient.notifyLanguageChanged();

    // Create new App instance with the new locale
    return App(
      initialLocale: locale,
      initialRoute: initialRoute,
    );
  }
}
