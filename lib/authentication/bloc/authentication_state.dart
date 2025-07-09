/// Authentication states for the [AuthenticationBloc].
///
/// This file defines all possible states that the authentication bloc can emit.
/// States represent the current authentication status of the user and any
/// associated data or error information.
///
/// **State Types:**
/// * [AuthenticationState.unknown] - Initial/loading state
/// * [AuthenticationState.authenticated] - User is logged in with user data
/// * [AuthenticationState.unauthenticated] - User is not logged in
/// * [AuthenticationState.error] - Error occurred during authentication
/// * [AuthenticationState.passwordResetEmailSent] - Password reset email sent
///
/// The state uses the [Equatable] mixin for efficient comparison and
/// rebuilding optimization in Flutter widgets.
part of 'authentication_bloc.dart';

/// Represents the authentication state of the application.
///
/// This class encapsulates all possible authentication states and their
/// associated data. It uses named constructors to provide type-safe
/// state creation and follows the sealed class pattern for exhaustive
/// pattern matching.
///
/// **Properties:**
/// * [status] - The current authentication status from [AuthenticationStatus]
/// * [user] - The authenticated user data (if available)
/// * [error] - Error message (if an error occurred)
///
/// **State Transitions:**
/// ```
/// unknown → authenticated (successful login/auto-login)
/// unknown → unauthenticated (no valid session)
/// authenticated → unauthenticated (logout)
/// unauthenticated → authenticated (successful login)
/// any → error (authentication error)
/// any → passwordResetEmailSent (password reset success)
/// ```
class AuthenticationState extends Equatable {
  /// Creates an authenticated state with user data.
  ///
  /// This state indicates that the user is successfully authenticated
  /// and their user data has been fetched from the user repository.
  ///
  /// **Parameters:**
  /// * [user] - The authenticated user's data and profile information
  ///
  /// **Usage:**
  /// ```dart
  /// AuthenticationState.authenticated(currentUser)
  /// ```
  const AuthenticationState.authenticated(User user)
    : this._(status: AuthenticationStatus.authenticated, user: user);

  /// Creates an error state with an error message.
  ///
  /// This state indicates that an error occurred during authentication
  /// operations. The user is considered unauthenticated when in error state.
  ///
  /// **Parameters:**
  /// * [errorMessage] - Description of the error that occurred
  ///
  /// **Usage:**
  /// ```dart
  /// AuthenticationState.error('Invalid credentials')
  /// ```
  const AuthenticationState.error(String errorMessage)
    : this._(status: AuthenticationStatus.unauthenticated, error: errorMessage);

  /// Creates a state indicating password reset email was sent successfully.
  ///
  /// This state is emitted after a successful password reset email request.
  /// The user remains unauthenticated but receives confirmation that the
  /// reset email was sent.
  ///
  /// **Usage:**
  /// ```dart
  /// AuthenticationState.passwordResetEmailSent()
  /// ```
  const AuthenticationState.passwordResetEmailSent()
    : this._(status: AuthenticationStatus.unauthenticated);

  /// Creates an unauthenticated state.
  ///
  /// This state indicates that no user is currently logged in.
  /// This is the target state after logout or when authentication fails.
  ///
  /// **Usage:**
  /// ```dart
  /// AuthenticationState.unauthenticated()
  /// ```
  const AuthenticationState.unauthenticated()
    : this._(status: AuthenticationStatus.unauthenticated);

  /// Creates an unknown authentication state.
  ///
  /// This is the initial state when the authentication status is being
  /// determined. It's typically shown during app startup while checking
  /// for existing authentication sessions.
  ///
  /// **Usage:**
  /// ```dart
  /// AuthenticationState.unknown()
  /// ```
  const AuthenticationState.unknown() : this._();

  /// Private constructor for creating authentication states.
  ///
  /// This constructor is used internally by the named constructors to
  /// create states with specific parameters. It provides default values
  /// for optional parameters.
  ///
  /// **Parameters:**
  /// * [status] - Authentication status (defaults to unknown)
  /// * [user] - User data (defaults to empty user)
  /// * [error] - Error message (optional)
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
    this.error,
  });

  /// The current authentication status.
  ///
  /// This indicates whether the user is authenticated, unauthenticated,
  /// or if the status is unknown (still being determined).
  final AuthenticationStatus status;

  /// The authenticated user data.
  ///
  /// Contains user profile information when authenticated.
  /// Defaults to [User.empty] when unauthenticated or unknown.
  final User user;

  /// Error message if an authentication error occurred.
  ///
  /// Contains descriptive error message for user feedback.
  /// Null when no error has occurred.
  final String? error;

  /// Properties used for state comparison by [Equatable].
  ///
  /// This ensures that the bloc only emits new states when the
  /// authentication status, user data, or error message actually changes.
  @override
  List<Object?> get props => [status, user, error];
}
