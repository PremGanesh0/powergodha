/// Authentication events for the [AuthenticationBloc].
///
/// This file defines all events that can be dispatched to the
/// [AuthenticationBloc] to trigger authentication-related operations.
///
/// **Event Types:**
/// * [AuthenticationSubscriptionRequested] - Start listening to auth status
/// * [AuthenticationLogoutPressed] - Handle user logout action
/// * [AuthenticationForgotPasswordRequested] - Handle password reset request
///
/// Events follow the sealed class pattern for exhaustive pattern matching
/// and type safety. Each event represents a user action or system trigger
/// that should result in authentication state changes.
part of 'authentication_bloc.dart';

/// Base class for all authentication events.
///
/// This sealed class ensures that all authentication events are handled
/// exhaustively in the bloc's event handlers. It provides type safety
/// and prevents runtime errors from unhandled event types.
sealed class AuthenticationEvent {
  /// Base constructor for authentication events.
  const AuthenticationEvent();
}

/// Event to request a password reset email for the given email address.
///
/// This event is typically dispatched when a user clicks "Forgot Password"
/// on the login screen and provides their email address.
///
/// **Properties:**
/// * [email] - The email address to send the password reset link to
///
/// **Triggers:** Password reset email sending process
/// **Result:** [AuthenticationState.passwordResetEmailSent] or [AuthenticationState.error]
final class AuthenticationForgotPasswordRequested extends AuthenticationEvent {
  /// Creates a password reset request event.
  ///
  /// **Parameters:**
  /// * [email] - Valid email address for password reset
  const AuthenticationForgotPasswordRequested({required this.email});

  /// The email address to send the password reset email to.
  ///
  /// This should be a valid email address that exists in the system.
  /// The authentication repository will handle validation and sending.
  final String email;
}

/// Event to handle user logout action.
///
/// This event is dispatched when a user explicitly logs out of the application.
/// It triggers the logout process in the authentication repository, which will
/// clear stored tokens and update the authentication status.
///
/// **Triggers:** User logout process
/// **Result:** Authentication status changes to unauthenticated
final class AuthenticationLogoutPressed extends AuthenticationEvent {}

/// Event to start listening to authentication status changes.
///
/// This event is typically dispatched during app initialization to start
/// the subscription to authentication status changes. It sets up the stream
/// that keeps the bloc synchronized with the authentication repository.
///
/// **Triggers:** Authentication status subscription
/// **Result:** Continuous authentication state updates based on repository status
final class AuthenticationSubscriptionRequested extends AuthenticationEvent {}
