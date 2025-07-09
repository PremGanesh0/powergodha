/// Routing system exports for the PowerGodha application.
///
/// This file provides convenient access to all routing-related classes
/// and utilities. Import this file to access the complete routing system.
///
/// **Exported Components:**
/// * [AppRoutes] - Route constants and configuration
/// * [NavigationHelper] - Navigation utility methods
///
/// **Usage:**
/// ```dart
/// import 'package:powergodha/app/app_routing.dart';
///
/// // Use route constants
/// Navigator.pushNamed(context, AppRoutes.login);
///
/// // Use navigation helpers
/// await NavigationHelper.navigateToLogin(context);
/// ```
library;

import 'package:powergodha/app/app_routes.dart' show AppRoutes;
import 'package:powergodha/app/app_routing.dart' show AppRoutes;

export 'app_routes.dart';
