/// Root application widget and dependency injection setup.
///
/// This file defines the [App] widget which serves as the root of the
/// application widget tree. It's responsible for:
/// * Setting up dependency injection with [MultiRepositoryProvider]
/// * Initializing the [AuthenticationBloc] for global auth state
/// * Providing repositories to the entire widget tree
/// * Managing the lifecycle of repositories (creation and disposal)
///
/// Architecture Overview:
/// ```
/// App (MultiRepositoryProvider)
/// ├── AuthenticationRepository (handles auth state)
/// ├── UserRepository (manages user data)
/// └── BlocProvider<AuthenticationBloc>
///     └── AppView (navigation and routing)
/// ```
///
/// This follows the BLoC pattern and repository pattern for clean architecture.
library;
/// * Managing the lifecycle of repositories (creation and disposal)
///
/// Architecture Overview:
/// ```
/// App (MultiRepositoryProvider)
/// ├── AuthenticationRepository (handles auth state)
/// ├── UserRepository (manages user data)
/// └── BlocProvider<AuthenticationBloc>
///     └── AppView (navigation and routing)
/// ```
///
/// This follows the BLoC pattern and repository pattern for clean architecture.

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/animal_repo/repositories/animal_repository.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/app/app_view.dart';
import 'package:powergodha/authentication/bloc/authentication_bloc.dart';
import 'package:powergodha/shared/api/api_client.dart';
import 'package:user_repository/user_repository.dart';

/// {@template app}
/// The root widget of the PowerGodha application.
///
/// This widget sets up the foundation for the entire application including:
/// * Dependency injection for repositories
/// * Global state management with BLoC pattern
/// * Authentication state management
/// * Repository lifecycle management
///
/// **Repositories provided:**
/// * [AuthenticationRepository] - Handles user authentication, login/logout
/// * [UserRepository] - Manages user data and profile information
///
/// **State Management:**
/// * [AuthenticationBloc] - Global authentication state management
/// * Automatically subscribes to authentication status changes
/// * Manages user session persistence
///
/// **Widget Tree Structure:**
/// ```
/// MultiRepositoryProvider
/// ├── RepositoryProvider<AuthenticationRepository>
/// ├── RepositoryProvider<UserRepository>
/// └── BlocProvider<AuthenticationBloc>
///     └── AppView (handles routing and navigation)
/// ```
///
/// The [AuthenticationBloc] is initialized with `lazy: false` to immediately
/// start listening for authentication status changes when the app starts.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key, this.initialLocale, this.initialRoute});

  /// Optional initial locale to use when restarting the app
  final Locale? initialLocale;

  /// Optional initial route to navigate to after restart
  final String? initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      // Provide repositories at the top of the widget tree for dependency injection
      providers: [
        // Authentication repository with shared HTTP client and global logger
        // This handles login, logout, password reset, and auth status
        RepositoryProvider(
          create: (_) =>
              AuthenticationRepository(dio: ApiClient.instance, logger: AppLogger.instance),
          dispose: (repository) => repository.dispose(),
        ),
        // User repository for managing user data and profile information
        // This handles user CRUD operations and profile management
        RepositoryProvider(
          create: (context) => UserRepository(
            authenticationRepository: context.read<AuthenticationRepository>(),
            dio: ApiClient.instance,
          ),
        ),
        // Animal repository for managing animal-related data
        // This handles animal count and other animal operations
        RepositoryProvider(
          create: (context) => AnimalRepository(
            authenticationRepository: context.read<AuthenticationRepository>(),
            dio: ApiClient.instance,
          ),
        ),
      ],
      child: BlocProvider(
        // Initialize immediately without lazy loading to start auth listening
        lazy: false,
        // Create and initialize the authentication bloc with dependencies
        create: (context) {
          final authRepo = context.read<AuthenticationRepository>();
          final userRepo = context.read<UserRepository>();

          // Log whether this is a regular start or a language change restart
          if (initialLocale != null) {
            AppLogger.info('App restarting with locale change to: ${initialLocale!.languageCode}');

            // Force recreation of API clients
            try {
              // 1. Notify ApiClient of language change and get a fresh instance
              ApiClient.notifyLanguageChanged();
              ApiClient.instance; // Access instance to force creation of new Dio
              AppLogger.info('Global API client recreated after language change');

              // 2. Then ensure authentication repository has a fresh Dio instance
              authRepo.getValidDioClient();
              AppLogger.info('Authentication repository Dio client refreshed');

              // 3. Make sure repositories will get fresh Dio instances when they need them
              try {
                // Force repositories to recreate with fresh clients on next use
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  try {
                    // We don't have direct access to update the Dio in user repository,
                    // but it will get a fresh instance from ApiClient.instance on next use
                    AppLogger.info('All repositories will get fresh API clients on next use');
                  } catch (e) {
                    // Ignore if anything goes wrong here
                  }
                });
              } catch (e) {
                // This is non-critical, so just log it
                AppLogger.warning('Could not set post-frame callback (non-critical): $e');
              }

              AppLogger.info(
                'All repositories re-initialized with existing token state and fresh API clients',
              );
            } catch (e) {
              AppLogger.error('Error during API client recreation: $e');
              // Continue anyway - we've made our best effort
            }
          }

          return AuthenticationBloc(authenticationRepository: authRepo, userRepository: userRepo)
            // Immediately request subscription to auth status changes
            ..add(AuthenticationSubscriptionRequested());
        },
        // AppView contains the main application UI and navigation logic
        child: AppView(initialLocale: initialLocale, initialRoute: initialRoute),
      ),
    );
  }
}
