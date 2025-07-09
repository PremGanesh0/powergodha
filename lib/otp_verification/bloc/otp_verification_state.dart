part of 'otp_verification_bloc.dart';

/// State for OTP verification.
final class OtpVerificationState extends Equatable {
  const OtpVerificationState({
    this.otp = const Otp.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.error = '',
    this.otpResponse,
  });

  /// The current OTP input.
  final Otp otp;

  /// The submission status of the OTP verification.
  final FormzSubmissionStatus status;

  /// Whether the form is valid.
  final bool isValid;

  /// Any error message.
  final String error;

  /// The OTP verification response after successful verification.
  final OtpVerificationResponse? otpResponse;

  @override
  List<Object?> get props => [otp, status, isValid, error, otpResponse];

  /// Creates a copy of this state with the given fields replaced.
  OtpVerificationState copyWith({
    Otp? otp,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? error,
    OtpVerificationResponse? otpResponse,
  }) {
    return OtpVerificationState(
      otp: otp ?? this.otp,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      otpResponse: otpResponse ?? this.otpResponse,
    );
  }
}
