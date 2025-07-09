import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:powergodha/otp_verification/models/otp.dart';

part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

/// {@template otp_verification_bloc}
/// A BLoC that manages OTP verification state and events.
/// {@endtemplate}
class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  /// {@macro otp_verification_bloc}
  OtpVerificationBloc({
    required AuthenticationRepository authenticationRepository,
    required String phoneNumber,
    required int userId,
  })  : _authenticationRepository = authenticationRepository,
        _phoneNumber = phoneNumber,
        _userId = userId,
        super(const OtpVerificationState()) {
    on<OtpChanged>(_onOtpChanged);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<ResendOtpRequested>(_onResendOtpRequested);
  }

  final AuthenticationRepository _authenticationRepository;
  final String _phoneNumber;
  final int _userId;

  void _onOtpChanged(
    OtpChanged event,
    Emitter<OtpVerificationState> emit,
  ) {
    final otp = Otp.dirty(event.otp);
    emit(
      state.copyWith(
        otp: otp,
        isValid: otp.isValid,
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<OtpVerificationState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final otpResponse = await _authenticationRepository.verifyOtp(
          phoneNumber: _phoneNumber,
          otp: state.otp.value,
          userId: _userId,
        );
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          otpResponse: otpResponse,
        ));
      } on AuthenticationException catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          error: e.message,
        ));
      }
    }
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      // In a real app, you might want to call a resend OTP API
      // For now, we'll just show success
      emit(state.copyWith(
        status: FormzSubmissionStatus.initial,
        error: '',
      ));
      // You could emit a temporary success state to show "OTP sent" message
    } on AuthenticationException catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        error: e.message,
      ));
    }
  }
}
