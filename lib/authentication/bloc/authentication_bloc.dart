/// Global authentication state management using BLoC pattern.
///
/// This file contains the [AuthenticationBloc] which manages the application's
/// global authentication state. It serves as the single source of truth for
/// authentication status throughout the app.
///
/// **Responsibilities:**
/// * Listen to authentication status changes from [AuthenticationRepository]
/// * Handle authentication events (login, logout, password reset)
/// * Emit appropriate authentication states
/// * Coordinate between authentication and user repositories
/// * Handle error states and edge cases
///
/// **Events Handled:**
/// * [AuthenticationSubscriptionRequested] - Start listening to auth changes
/// * [AuthenticationLogoutPressed] - Handle user logout
/// * [AuthenticationForgotPasswordRequested] - Handle password reset requests
///
/// **States Emitted:**
/// * [AuthenticationState.unknown] - Initial/loading state
/// * [AuthenticationState.authenticated] - User is logged in
/// * [AuthenticationState.unauthenticated] - User is not logged in
/// * [AuthenticationState.passwordResetEmailSent] - Password reset email sent
/// * [AuthenticationState.error] - Error occurred during authentication
///
/// This bloc follows the single responsibility principle and uses the
/// repository pattern for data access.
library;

import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// {@template authentication_bloc}
/// A [Bloc] that manages the global authentication state of the application.
///
/// This bloc serves as the central hub for all authentication-related operations
/// and state management. It coordinates between the [AuthenticationRepository]
/// and [UserRepository] to provide a unified authentication experience.
///
/// **Key Features:**
/// * Stream-based authentication status monitoring
/// * Automatic user data fetching on authentication
/// * Error handling and recovery
/// * Password reset functionality
/// * Clean logout handling
///
/// **Dependencies:**
/// * [AuthenticationRepository] - Handles low-level auth operations
/// * [UserRepository] - Manages user data and profile information
///
/// **Lifecycle:**
/// 1. Initialized with unknown authentication state
/// 2. Subscribes to authentication status stream
/// 3. Automatically fetches user data when authenticated
/// 4. Emits appropriate states based on auth status changes
///
/// **Usage:**
/// ```dart
/// // Initialize the bloc
/// final authBloc = AuthenticationBloc(
///   authenticationRepository: authRepo,
///   userRepository: userRepo,
/// );
///
/// // Start listening to auth changes
/// authBloc.add(AuthenticationSubscriptionRequested());
///
/// // Handle logout
/// authBloc.add(AuthenticationLogoutPressed());
/// ```
/// {@endtemplate}
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// {@macro authentication_bloc}
  ///
  /// Creates an [AuthenticationBloc] with the required repositories.
  ///
  /// **Parameters:**
  /// * [authenticationRepository] - Repository for authentication operations
  /// * [userRepository] - Repository for user data operations
  ///
  /// The bloc starts in [AuthenticationState.unknown] state and registers
  /// event handlers for all supported authentication events.
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  }) : _authenticationRepository = authenticationRepository,
       _userRepository = userRepository,
       super(const AuthenticationState.unknown()) {
    // Register event handlers
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
    on<AuthenticationForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  /// Repository for handling authentication operations.
  ///
  /// This repository provides:
  /// * Authentication status stream
  /// * Login/logout functionality
  /// * Password reset operations
  /// * Token management
  final AuthenticationRepository _authenticationRepository;

  /// Repository for handling user data operations.
  ///
  /// This repository provides:
  /// * User profile data fetching
  /// * User data caching
  /// * Profile update operations
  final UserRepository _userRepository;
  /// Handles the [AuthenticationForgotPasswordRequested] event.
  ///
  /// This method processes password reset requests by:
  /// 1. Calling the authentication repository to send reset email
  /// 2. Emitting success state if email is sent successfully
  /// 3. Emitting error state if the operation fails
  ///
  /// **Event:** [AuthenticationForgotPasswordRequested]
  /// **Emits:** [AuthenticationState.passwordResetEmailSent] or [AuthenticationState.error]
  ///
  /// **Error Handling:**
  /// Any exceptions thrown by the repository are caught and converted to
  /// error states with the error message for user feedback.
  Future<void> _onForgotPasswordRequested(
    AuthenticationForgotPasswordRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      // Request password reset email from the authentication repository
      await _authenticationRepository.requestPasswordReset(event.email);
      // Emit success state to notify UI that email was sent
      emit(const AuthenticationState.passwordResetEmailSent());
    } catch (error) {
      // Emit error state with error message for user feedback
      emit(AuthenticationState.error(error.toString()));
    }
  }
  /// Handles the [AuthenticationLogoutPressed] event.
  ///
  /// This method processes logout requests by calling the authentication
  /// repository's logout method. The logout operation will trigger a status
  /// change in the authentication stream, which will be handled by the
  /// subscription in [_onSubscriptionRequested].
  ///
  /// **Event:** [AuthenticationLogoutPressed]
  /// **Side Effects:** Triggers authentication status change to unauthenticated
  ///
  /// **Flow:**
  /// 1. Call repository logout method
  /// 2. Repository updates authentication status
  /// 3. Status stream emits unauthenticated status
  /// 4. Subscription handler emits [AuthenticationState.unauthenticated]
  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    // Trigger logout in the repository
    // This will cause the authentication status stream to emit unauthenticated
    _authenticationRepository.logOut();
  }
  /// Handles the [AuthenticationSubscriptionRequested] event.
  ///
  /// This method sets up a subscription to the authentication status stream
  /// and emits appropriate states based on the authentication status changes.
  /// This is the core method that keeps the bloc synchronized with the
  /// authentication repository.
  ///
  /// **Event:** [AuthenticationSubscriptionRequested]
  /// **Emits:** Various [AuthenticationState] based on status changes
  ///
  /// **Status Mapping:**
  /// * [AuthenticationStatus.unauthenticated] → [AuthenticationState.unauthenticated]
  /// * [AuthenticationStatus.authenticated] → [AuthenticationState.authenticated] with user data
  /// * [AuthenticationStatus.unknown] → [AuthenticationState.unknown]
  ///
  /// **User Data Handling:**
  /// When authenticated, this method attempts to fetch user data. If user data
  /// cannot be retrieved, it falls back to unauthenticated state for security.
  ///  /// **Error Handling:**
  /// Stream errors are passed to the bloc's error handler via [addError].
  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) => emit.onEach(
    _authenticationRepository.status,
    onData: (AuthenticationStatus status) async {
      switch (status) {
        case AuthenticationStatus.unauthenticated:
          return emit(const AuthenticationState.unauthenticated());
        case AuthenticationStatus.authenticated:
          // User is authenticated - try to fetch user data
          final user = await _tryGetUser();
          return emit(
            user != null
                // Successfully got user data - emit authenticated state with user
                ? AuthenticationState.authenticated(user)
                // Failed to get user data - fallback to unauthenticated for security
                : const AuthenticationState.unauthenticated(),
          );
        case AuthenticationStatus.unknown:
          return emit(const AuthenticationState.unknown());
      }
    },
    // Forward any stream errors to the bloc's error handler
    onError: addError,
  );
  /// Attempts to fetch user data from the user repository.
  ///
  /// This is a helper method that safely attempts to retrieve user data
  /// when the authentication status is authenticated. It includes error
  /// handling to prevent the app from crashing if user data cannot be fetched.
  ///
  /// **Returns:**
  /// * [User] object if successfully fetched
  /// * `null` if an error occurs during fetching
  ///
  /// **Error Handling:**
  /// Any exceptions thrown by the user repository are caught and null is
  /// returned. This ensures that authentication failures don't crash the app
  /// and allows for graceful fallback to unauthenticated state.
  ///
  /// **Use Cases:**
  /// * Initial app startup when checking existing authentication
  /// * After successful login to fetch user profile  /// * When refreshing user data after authentication changes
  Future<User?> _tryGetUser() async {
    try {
      // Attempt to fetch user data from the repository with caching
      final user = await _userRepository.getUserWithCaching();
      return user;
    } catch (e) {
      // If any error occurs, return null to indicate failure
      // This could happen due to network issues, server errors, or invalid tokens
      return null;
    }
  }
}
