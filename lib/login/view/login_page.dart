/// Login page implementation with BLoC state management.
///
/// This file contains the [LoginPage] widget which serves as the entry point
/// for user authentication. It provides a complete login interface with:
/// * Form-based email and password input
/// * Login validation and submission
/// * Error handling and user feedback
/// * Navigation integration with the app's routing system
///
/// **Architecture:**
/// * Uses [LoginBloc] for form state management and login logic
/// * Integrates with [AuthenticationRepository] for authentication operations
/// * Contains [LoginForm] widget for the actual form UI
/// * Provides static route method for navigation integration
///
/// **Dependencies:**
/// * [AuthenticationRepository] - Injected from parent widget tree
/// * [LoginBloc] - Created and provided to child widgets
/// * [LoginForm] - Child widget containing form UI
///
/// This page follows the BLoC pattern for separation of concerns and
/// provides a clean interface for user authentication.
library;

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/app/app_routes.dart' show AppRoutes;
import 'package:powergodha/app/app_routing.dart' show AppRoutes;
import 'package:powergodha/app/app_view.dart' show AppView;
import 'package:powergodha/login/bloc/login_bloc.dart';
import 'package:powergodha/login/view/login_form.dart';

/// {@template login_page}
/// A page that provides the complete login interface for user authentication.
///
/// This [StatelessWidget] serves as a container for the login functionality and
/// is responsible for:
/// * Setting up the page layout with [Scaffold] and proper padding
/// * Creating and providing [LoginBloc] for form state management
/// * Hosting the [LoginForm] widget that contains the actual UI elements
/// * Integrating with the authentication system via [AuthenticationRepository]
///
/// **BLoC Integration:**
/// * Creates a [LoginBloc] with dependency injection from parent context
/// * Provides the bloc to child widgets via [BlocProvider]
/// * Ensures proper state management for login operations
///
/// **Layout Structure:**
/// ```
/// Scaffold
/// └── Padding (12px all around)
///     └── BlocProvider<LoginBloc>
///         └── LoginForm (contains form fields and buttons)
/// ```
///
/// **Navigation:**
/// * Provides static [route] method for backward compatibility
/// * Integrated with centralized routing system via [AppRoutes]
/// * Used by [AppView] when user is unauthenticated
/// * Supports both direct navigation and named route navigation
///
/// **Usage:**
/// ```dart
/// // Navigate using named routes (recommended)
/// Navigator.pushNamed(context, AppRoutes.login);
///
/// // Or use static route method for backward compatibility
/// Navigator.push(context, LoginPage.route());
/// ```
/// {@endtemplate}
class LoginPage extends StatelessWidget {
  /// {@macro login_page}
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(12),
      child: BlocProvider(
        // Create and provide LoginBloc to the widget subtree
        create: (context) => LoginBloc(
          // Inject AuthenticationRepository from the parent context
          // This repository handles the actual authentication operations
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        // LoginForm contains the actual login UI elements and form logic
        child: const LoginForm(),
      ),
    ),
  );
  static Route<void> route() => MaterialPageRoute<void>(builder: (_) => const LoginPage());
}
