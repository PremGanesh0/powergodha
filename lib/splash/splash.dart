/// Splash Module Barrel Export
///
/// This file serves as the main entry point for the splash module,
/// providing convenient access to all splash screen components.
///
/// **Exported Components:**
/// * [SplashPage] - Initial loading screen displayed during app startup
///
/// **Module Structure:**
/// * `view/` - UI components including the splash page
/// * `splash.dart` - This barrel export file
///
/// **Usage:**
/// ```dart
/// import 'package:powergodha/splash/splash.dart';
///
/// // Splash components are now available
/// MaterialApp(
///   onGenerateRoute: (_) => SplashPage.route(),
/// )
/// ```
///
/// **Purpose:**
/// * Provides initial screen during app startup
/// * Gives time for authentication system initialization
/// * Improves user experience during app loading
/// * Serves as entry point before authentication routing
/// * Foundation for future loading animations and branding
///
/// **Integration:**
/// * Used as initial route in [AppView]
/// * Replaced by [HomePage] or [LoginPage] based on auth status
/// * Part of the authentication flow chain
/// * Removed from navigation stack after auth determination
///
/// **Features:**
/// * Simple, clean loading interface
/// * Placeholder for future enhancements
/// * Consistent entry point for all users
/// * Smooth transition to appropriate screens
///
/// **Future Enhancements:**
/// * Company branding and logo display
/// * Loading animations and progress indicators
/// * App version information
/// * Initialization status feedback
/// * Custom transition animations
///
/// This module provides the foundation for a professional app startup
/// experience and can be enhanced with branding and animation elements.
library splash;

import 'package:powergodha/app/app_view.dart' show AppView;
import 'package:powergodha/home/home.dart' show HomePage;
import 'package:powergodha/home/view/home_page.dart' show HomePage;
import 'package:powergodha/login/login.dart' show LoginPage;
import 'package:powergodha/login/view/login_page.dart' show LoginPage;
import 'package:powergodha/login/view/view.dart' show LoginPage;
import 'package:powergodha/splash/splash.dart' show SplashPage;
import 'package:powergodha/splash/view/splash_page.dart' show SplashPage;

export 'view/splash_page.dart';
