import 'package:formz/formz.dart';

/// {@template otp}
/// Form input for an OTP input.
/// {@endtemplate}
class Otp extends FormzInput<String, OtpValidationError> {
  /// {@macro otp}
  const Otp.dirty([super.value = '']) : super.dirty();

  /// {@macro otp}
  const Otp.pure() : super.pure('');

  static final _otpRegExp = RegExp(
    r'^\d{6}$', // 6-digit OTP format
  );

  @override
  OtpValidationError? validator(String? value) {
    if (value?.isEmpty ?? true) return OtpValidationError.empty;
    if (value != null && value.length < 6) return OtpValidationError.tooShort;
    if (value != null && value.length > 6) return OtpValidationError.tooLong;
    return _otpRegExp.hasMatch(value ?? '') ? null : OtpValidationError.invalid;
  }
}

/// Validation errors for the OTP input.
enum OtpValidationError {
  /// Generic invalid error.
  invalid,
  /// OTP is empty.
  empty,
  /// OTP is too short.
  tooShort,
  /// OTP is too long.
  tooLong,
}
