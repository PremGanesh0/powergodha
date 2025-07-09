part of 'login_bloc.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.phoneNumber = const PhoneNumber.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.error,
    this.authResponse,
  });

  final FormzSubmissionStatus status;
  final PhoneNumber phoneNumber;
  final Password password;
  final bool isValid;
  final String? error;
  final AuthResponse? authResponse;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    PhoneNumber? phoneNumber,
    Password? password,
    bool? isValid,
    String? error,
    AuthResponse? authResponse,
  }) => LoginState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      authResponse: authResponse ?? this.authResponse,
    );

  @override
  List<Object?> get props => [
        status,
        phoneNumber,
        password,
        isValid,
        error,
        authResponse,
      ];
}
