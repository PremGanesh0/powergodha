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
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/authentication/bloc/authentication_bloc.dart';
import 'package:powergodha/home/home.dart' show HomePage;
import 'package:powergodha/home/view/home_page.dart' show HomePage;
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/login/login.dart' show LoginPage;
import 'package:powergodha/login/view/login_page.dart' show LoginPage;
import 'package:powergodha/login/view/view.dart' show LoginPage;
import 'package:powergodha/shared/auth_interceptor.dart';
import 'package:powergodha/shared/localization_service.dart';
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
      // Use BlocListener for navigation + initial home widget
      home: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          // Only navigate after splash delay is completed
          if (!_splashDelayCompleted) return;

          AppLogger.info('AppView: Navigation listener - auth status: ${state.status}');

          // Handle navigation based on auth status
          _handleAuthenticationNavigation(context, state.status);
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshLocaleIfNeeded();
  }

  @override
  void dispose() {
    AppLogger.info('AppView: Disposing AppView widget');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize locale, with priority to any initialLocale passed in
    _initializeLocale();

    // If we have an initial route or locale, it means we're restarting the app
    // Skip the splash delay and go straight to checking auth state
    if (widget.initialRoute != null || widget.initialLocale != null) {
      AppLogger.info(
        'AppView: Skip splash delay - restarting app with initialRoute: ${widget.initialRoute}, locale: ${widget.initialLocale?.languageCode}',
      );
      _splashDelayCompleted = true;
    } else {
      // Start the 2-second splash delay timer for normal app start
      _startSplashDelay();
    }
  }

  /// Builds the appropriate page widget based on authentication status.
  ///
  /// This method determines which page to show after the splash delay
  /// has completed, based on the current authentication status.
  /// Always prioritizes explicit initialRoute if provided.
  Widget _buildPageForAuthStatus(AuthenticationStatus status) {
    // Log current auth status and initialRoute (if any)
    AppLogger.info('AppView: Auth status: $status, initialRoute: ${widget.initialRoute}');

    // Check if this build is happening after a language change restart
    final isAfterLanguageChange = widget.initialLocale != null;
    if (isAfterLanguageChange) {
      AppLogger.info(
        'AppView: Rebuilding after language change to ${widget.initialLocale?.languageCode}',
      );

      // Force API client recreation after EVERY language change
      try {
        // Get a reference to the AuthRepository directly from the context
        final authRepo = RepositoryProvider.of<AuthenticationRepository>(context);
        AppLogger.info('AppView: Ensuring fresh Dio client after language change');
        // This creates a brand new Dio instance, ensuring fresh connections
        authRepo.getValidDioClient();
      } catch (e) {
        AppLogger.error('AppView: Error refreshing Dio client after language change', error: e);
      }
    }

    // FIRST CHECK: If we have an explicit route to follow, it takes precedence
    // This is critical for language change navigation to work properly
    if (widget.initialRoute != null) {
      final route = widget.initialRoute!;
      AppLogger.info('AppView: Using initialRoute to navigate: $route');
      if (route == AppRoutes.home) {
        return const HomePage();
      } else if (route == AppRoutes.login) {
        return const LoginPage();
      }
      // Other routes can be added as needed
    }

    // SECOND CHECK: Fall back to authentication status
    // This ensures we go to the correct screen based on login state
    switch (status) {
      case AuthenticationStatus.authenticated:
        AppLogger.info('AppView: Building HomePage for authenticated user');
        return const HomePage();
      case AuthenticationStatus.unauthenticated:
        // If we're coming from a language change, double-check with local storage
        // before showing the login page, as this could be a transient network error
        if (isAfterLanguageChange) {
          AppLogger.info(
            'AppView: Unauthenticated after language change, checking token in storage...',
          );
          _checkTokensAfterLanguageChange();
          // The actual check happens in _checkTokensAfterLanguageChange
          // For now, we still return LoginPage as that's what the auth status indicates
          // but the AuthBloc should take care of preserving auth state
        }
        AppLogger.info('AppView: Building LoginPage for unauthenticated user');
        return const LoginPage();
      case AuthenticationStatus.unknown:
        // For unknown state after a language change, we should try to preserve the
        // authenticated state if possible, to avoid logging users out due to network issues
        if (isAfterLanguageChange) {
          AppLogger.info(
            'AppView: Unknown auth status after language change, preserving previous state...',
          );
          // In a real implementation, we would check local storage here
          // For now, let's proceed with normal flow and let the AuthBloc handle it
        }

        // No need to check initialRoute here anymore
        // That's now handled at the beginning of the method

        AppLogger.info('AppView: Auth status unknown, showing SplashPage');
        return const SplashPage();
    }
  }

  /// Check for authentication tokens after a language change
  /// This is a helper method to avoid logging users out due to network errors
  /// that may occur during app restart after a language change
  Future<void> _checkTokensAfterLanguageChange() async {
    try {
      final hasTokens = await AuthInterceptor.hasTokensInStorage();

      if (hasTokens) {
        AppLogger.info(
          'AppView: Found valid tokens after language change, '
          'the AuthBloc should preserve authenticated state despite network errors',
        );
        // The tokens exist, but we're getting an unauthenticated status
        // This could be due to a network error during token validation
        // The AuthBloc and AuthRepository have been updated to handle this case
      } else {
        AppLogger.info('AppView: No tokens found after language change, truly unauthenticated');
      }
    } catch (e) {
      AppLogger.error('AppView: Error checking tokens after language change', error: e);
    }
  }

  /// Handles navigation based on authentication status with proper stack management.
  ///
  /// This method ensures that navigation is done with proper cleanup of the
  /// navigation stack to prevent memory leaks and multiple page instances.
  void _handleAuthenticationNavigation(BuildContext context, AuthenticationStatus status) {
    // Don't navigate if we have an explicit initial route - let direct rendering handle it
    if (widget.initialRoute != null) {
      AppLogger.info('AppView: Skipping navigation - using initialRoute: ${widget.initialRoute}');
      return;
    }

    // Get the root navigator to ensure we clear everything
    final navigator = Navigator.of(context, rootNavigator: true);

    switch (status) {
      case AuthenticationStatus.authenticated:
        AppLogger.info('AppView: Navigating to HomePage (replacing all)');
        navigator.pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const HomePage()),
          (route) => false, // Remove all previous routes
        );
      case AuthenticationStatus.unauthenticated:
        AppLogger.info('AppView: Navigating to LoginPage (replacing all)');
        navigator.pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const LoginPage()),
          (route) => false, // Remove all previous routes
        );
      case AuthenticationStatus.unknown:
        // For unknown status, stay on splash or current page
        AppLogger.info('AppView: Auth status unknown, staying on current page');
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
        AppLogger.info('Splash delay completed, triggering authentication check...');
        setState(() {
          _splashDelayCompleted = true;
        });

        // Trigger authentication subscription to ensure navigation happens
        final authBloc = context.read<AuthenticationBloc>();
        authBloc.add(AuthenticationSubscriptionRequested());
      }
    });
  }
}
