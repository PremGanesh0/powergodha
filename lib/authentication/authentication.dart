/// Authentication Module Barrel Export
///
/// This file serves as the main entry point for the authentication module,
/// providing convenient access to all authentication-related components.
///
/// **Exported Components:**
/// * [AuthenticationBloc] - Global authentication state management
/// * [AuthenticationEvent] - All authentication events
/// * [AuthenticationState] - All authentication states
///
/// **Usage:**
/// ```dart
/// import 'package:powergodha/authentication/authentication.dart';
///
/// // All authentication components are now available
/// final authBloc = AuthenticationBloc(...);
/// authBloc.add(AuthenticationSubscriptionRequested());
/// ```
///
/// **Purpose:**
/// * Simplifies imports throughout the application
/// * Provides clean API for authentication functionality
/// * Encapsulates authentication module implementation details
/// * Follows barrel export pattern for better organization
///
/// **Module Structure:**
/// * `bloc/` - Contains BLoC state management components
/// * `authentication.dart` - This barrel export file
///
/// This approach promotes clean architecture by providing a clear
/// interface to the authentication module while hiding implementation details.
library authentication;

import 'package:powergodha/authentication/authentication.dart'
    show AuthenticationBloc, AuthenticationEvent, AuthenticationState;
import 'package:powergodha/authentication/bloc/authentication_bloc.dart'
    show AuthenticationBloc, AuthenticationEvent, AuthenticationState;

export 'bloc/authentication_bloc.dart';
