/// Login Module Barrel Export
///
/// This file serves as the main entry point for the login module,
/// providing convenient access to all login-related components.
///
/// **Exported Components:**
/// * [LoginBloc] - Login form state management
/// * Login models and data structures
/// * [LoginPage] and [LoginForm] - UI components
/// * Login-specific events and states
///
/// **Module Structure:**
/// * `bloc/` - Contains BLoC state management for login forms
/// * `models/` - Login-specific data models and validation
/// * `view/` - UI components including page and form widgets
///
/// **Usage:**
/// ```dart
/// import 'package:powergodha/login/login.dart';
///
/// // All login components are now available
/// final loginBloc = LoginBloc(...);
/// Navigator.push(context, LoginPage.route());
/// ```
///
/// **Integration:**
/// * Works with [AuthenticationBloc] for global auth state
/// * Integrates with [AuthenticationRepository] for login operations
/// * Provides complete login flow from UI to authentication
/// * Handles form validation and user feedback
///
/// **Features:**
/// * Email and password validation
/// * Login form state management
/// * Error handling and user feedback
/// * Integration with authentication system
/// * Responsive UI design
///
/// This module demonstrates the BLoC pattern implementation for
/// feature-specific state management while integrating with global app state.
library login;

import 'package:authentication_repository/authentication_repository.dart'
    show AuthenticationRepository;
import 'package:powergodha/authentication/authentication.dart' show AuthenticationBloc;
import 'package:powergodha/authentication/bloc/authentication_bloc.dart' show AuthenticationBloc;
import 'package:powergodha/login/login.dart' show LoginBloc, LoginForm, LoginPage;

export 'bloc/login_bloc.dart';
export 'models/models.dart';
export 'view/view.dart';
