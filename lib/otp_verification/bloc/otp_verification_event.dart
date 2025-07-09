part of 'otp_verification_bloc.dart';

/// Event triggered when the OTP input changes.
final class OtpChanged extends OtpVerificationEvent {
  const OtpChanged(this.otp);

  /// The new OTP value.
  final String otp;

  @override
  List<Object> get props => [otp];
}

/// Event triggered when the OTP is submitted for verification.
final class OtpSubmitted extends OtpVerificationEvent {
  const OtpSubmitted();
}

/// Base class for all OTP verification events.
sealed class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when the user requests to resend the OTP.
final class ResendOtpRequested extends OtpVerificationEvent {
  const ResendOtpRequested();
}
