import 'package:formz/formz.dart';

/// {@template email}
/// Form input for an email field.
/// {@endtemplate}
class Email extends FormzInput<String, EmailValidationError> {
  /// {@macro email}
  const Email.dirty([super.value = '']) : super.dirty();

  /// {@macro email}
  const Email.pure() : super.pure('');

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!_emailRegExp.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }
}

/// Validation errors for the [Email] [FormzInput].
enum EmailValidationError {
  /// Email is empty
  empty,
  /// Email is invalid
  invalid
}
