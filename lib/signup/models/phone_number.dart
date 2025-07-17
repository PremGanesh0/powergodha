import 'package:formz/formz.dart';

/// {@template phone_number}
/// Form input for a phone number input.
/// {@endtemplate}
class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  static final _phoneRegExp = RegExp(
    r'^[6-9]\d{9}$', // Indian phone number format: starts with 6-9, followed by 9 digits
  );

  /// {@macro phone_number}
  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  /// {@macro phone_number}
  const PhoneNumber.pure() : super.pure('');

  @override
  PhoneNumberValidationError? validator(String? value) {
    if (value?.isEmpty == true) return PhoneNumberValidationError.empty;
    if (value != null && value.length < 10) return PhoneNumberValidationError.tooShort;
    if (value != null && value.length > 10) return PhoneNumberValidationError.tooLong;
    return _phoneRegExp.hasMatch(value ?? '') ? null : PhoneNumberValidationError.invalid;
  }
}

/// Validation errors for the phone number input.
enum PhoneNumberValidationError {
  /// Generic invalid error.
  invalid,
  /// Phone number is empty.
  empty,
  /// Phone number is too short.
  tooShort,
  /// Phone number is too long.
  tooLong,
}
