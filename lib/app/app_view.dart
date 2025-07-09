/// Application view and navigation management.
///
/// This file contains the [AppView] widget which is responsible for:
/// * Setting up the [MaterialApp] configuration
/// * Managing authentication-based widget rendering (no navigation flash)
/// * Providing named route generation for secondary navigation
/// * Handling authentication state changes with direct widget rendering
/// * Providing smooth transitions without intermediate page flashes
///
/// **Authentication Flow:**
/// 1. App starts with [SplashPage] directly rendered
/// 2. 2-second splash delay timer starts
/// 3. [AuthenticationBloc] determines authentication status asynchronously
/// 4. After 2-second delay completes, directly renders appropriate page:
///    - [HomePage] for authenticated users (no navigation flash)
///    - [LoginPage] for unauthenticated users
///    - Stays on [SplashPage] for unknown status
///
/// **Hybrid Navigation Strategy:**
/// * Uses direct widget rendering for authentication-based routing (prevents flash)
/// * Uses named route generation for secondary navigation (/signup, /forgot-password, etc.)
/// * Eliminates intermediate page transitions during authentication flow
/// * Maintains full routing capability for all other app navigation
///
/// **State Management Integration:**
/// * Uses [BlocBuilder] to directly render widgets based on authentication state
/// * No navigation calls during authentication flow = no page flashes
/// * Responsive to authentication state changes with immediate widget updates
///
/// This hybrid approach provides the best of both worlds: smooth authentication
/// flow without flashes, plus full named route support for app navigation.
library;

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/authentication/bloc/authentication_bloc.dart';
import 'package:powergodha/home/home.dart' show HomePage;
import 'package:powergodha/home/view/home_page.dart' show HomePage;
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/login/login.dart' show LoginPage;
import 'package:powergodha/login/view/login_page.dart' show LoginPage;
import 'package:powergodha/login/view/view.dart' show LoginPage;
import 'package:powergodha/shared/localization_service.dart';
import 'package:powergodha/app/logger_config.dart';
import 'package:powergodha/shared/theme.dart';
import 'package:powergodha/splash/splash.dart' show SplashPage;
import 'package:powergodha/splash/view/splash_page.dart' show SplashPage;

/// {@template app_view}
/// The main application view widget that handles authentication-based rendering
/// and named route navigation.
///
/// This [StatefulWidget] is responsible for:
/// * Setting up the [MaterialApp] with proper configuration
/// * Managing authentication state with direct widget rendering (no flash)
/// * Providing named route generation for secondary navigation
/// * Ensuring smooth authentication flow without intermediate page transitions
/// * Supporting full app navigation capabilities
///
/// **Authentication-based Rendering:**
/// * [AuthenticationStatus.authenticated] → Directly render [HomePage] after splash delay
/// * [AuthenticationStatus.unauthenticated] → Directly render [LoginPage] after splash delay
/// * [AuthenticationStatus.unknown] → Continue showing [SplashPage]
///
/// **Hybrid Navigation Strategy:**
/// * **Primary flow**: Direct widget rendering based on authentication state
/// * **Secondary flow**: Named route navigation for /signup, /forgot-password, etc.
/// * **Benefits**: No page flashes during auth flow + full routing support
///
/// **Integration with BLoC:**
/// * Uses [BlocBuilder] to directly render widgets based on authentication state
/// * Eliminates navigation-based transitions that could cause page flashes
/// * Responsive to authentication state changes with immediate widget updates
///
/// The widget provides a smooth user experience with no login screen flash
/// while maintaining full navigation capabilities for the rest of the app.
/// {@endtemplate}
class AppView extends StatefulWidget {
  /// {@macro app_view}
  const AppView({super.key, this.initialLocale, this.initialRoute});

  /// Optional initial locale to use when restarting the app
  final Locale? initialLocale;

  /// Optional initial route to bypass normal navigation flow
  /// and go directly to a specific screen
  final String? initialRoute;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  /// Global key for accessing the [NavigatorState] throughout the app.
  ///
  /// This key provides access to the navigator from anywhere in the widget tree,
  /// allowing for programmatic navigation without requiring a [BuildContext].
  /// It's particularly useful for:
  /// * Navigation triggered by BLoC events
  /// * Deep linking and route management
  /// * Handling navigation from non-widget classes
  ///
  /// **Usage Example:**
  /// ```dart
  /// _navigatorKey.currentState?.pushNamed('/new-route');
  /// ```
  final _navigatorKey = GlobalKey<NavigatorState>();

  /// Flag to track if the splash delay has completed.
  ///
  /// This prevents navigation from happening before the 2-second splash delay
  /// is complete, ensuring users see the splash screen for the minimum duration.
  bool _splashDelayCompleted = false;

  /// Current locale for the app - initialized with English by default
  /// to prevent LateInitializationError
  Locale _locale = const Locale('en');

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: const Size(375, 812), // Standard iPhone X size as design reference
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) => MaterialApp(
      navigatorKey: _navigatorKey,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      // Use BlocBuilder to control what gets shown instead of listener navigation
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          AppLogger.info(
            'AppView: Building with auth status: ${state.status}, splash completed: $_splashDelayCompleted',
          );

          // Always show splash if delay hasn't completed yet
          if (!_splashDelayCompleted) {
            return const SplashPage();
          }

          // After splash delay, show appropriate page based on auth status
          return _buildPageForAuthStatus(state.status);
        },
      ),
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     _refreshLocaleIfNeeded();
  }

  @override
  void initState() {
    super.initState();
    // Initialize locale, with priority to any initialLocale passed in
    _initializeLocale();
    // Start the 2-second splash delay timer
    _startSplashDelay();
  }

  /// Builds the appropriate page widget based on authentication status.
  ///
  /// This method determines which page to show after the splash delay
  /// has completed, based on the current authentication status.
  Widget _buildPageForAuthStatus(AuthenticationStatus status) {
    switch (status) {
      case AuthenticationStatus.authenticated:
        AppLogger.info('AppView: Building HomePage for authenticated user');
        return const HomePage();
      case AuthenticationStatus.unauthenticated:
        AppLogger.info('AppView: Building LoginPage for unauthenticated user');
        return const LoginPage();
      case AuthenticationStatus.unknown:
        AppLogger.info('AppView: Auth status unknown, showing SplashPage');
        return const SplashPage();
    }
  }

  /// Initialize the app locale from saved preferences or from initialLocale
  Future<void> _initializeLocale() async {
    if (widget.initialLocale != null) {
      // If we have an initial locale specified (from app restart), use it
      setState(() {
        _locale = widget.initialLocale!;
      });
      AppLogger.info('App locale force set to: ${_locale.languageCode}');
    } else {
      // Otherwise get the locale from preferences
      final locale = await LocalizationService.getCurrentLocale();
      if (mounted) {
        setState(() {
          _locale = locale;
        });
        AppLogger.info('App locale set to: ${_locale.languageCode}');
      }
    }
  }

  /// Check if we need to refresh the locale (useful when returning to the app)
  Future<void> _refreshLocaleIfNeeded() async {
    final currentLocale = await LocalizationService.getCurrentLocale();
    if (mounted && currentLocale.languageCode != _locale.languageCode) {
      setState(() {
        _locale = currentLocale;
      });
      AppLogger.info('Locale refreshed to: ${_locale.languageCode}');
    }
  }

  /// Starts the 2-second delay for the splash screen.
  ///
  /// After 2 seconds, sets [_splashDelayCompleted] to true which will
  /// trigger a rebuild and show the appropriate page based on auth status.
  void _startSplashDelay() {
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        AppLogger.info('Splash delay completed, rebuilding with current auth state...');
        setState(() {
          _splashDelayCompleted = true;
        });
      }
    });
  }
}
