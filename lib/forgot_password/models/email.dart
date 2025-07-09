import 'package:formz/formz.dart';

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class Email extends FormzInput<String, EmailValidationError> {
  /// {@macro email}
  const Email.dirty([super.value = '']) : super.dirty();

  /// {@macro email}
  const Email.pure() : super.pure('');

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '')
        ? null
        : EmailValidationError.invalid;
  }
}

/// Validation errors for the [Email] [FormzInput].
enum EmailValidationError {
  /// Email is invalid (does not match email regex)
  invalid
}
