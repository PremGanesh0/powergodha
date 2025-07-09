part of 'signup_bloc.dart';

final class SignupState extends Equatable {
  const SignupState({
    this.name = const Name.pure(),
    this.phoneNumber = const signup_models.PhoneNumber.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.error = '',
    this.registrationResponse,
  });

  final Name name;
  final signup_models.PhoneNumber phoneNumber;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String error;
  final RegistrationResponse? registrationResponse;

  @override
  List<Object?> get props => [
        name,
    phoneNumber,
        password,
        status,
        isValid,
        error,
    registrationResponse,
      ];

  SignupState copyWith({
    Name? name,
    signup_models.PhoneNumber? phoneNumber,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? error,
    RegistrationResponse? registrationResponse,
  }) {
    return SignupState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      registrationResponse: registrationResponse ?? this.registrationResponse,
    );
  }
}
