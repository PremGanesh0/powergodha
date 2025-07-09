import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../authentication/authentication.dart';
import '../models/email.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required AuthenticationBloc authenticationBloc,
  })  : _authenticationBloc = authenticationBloc,
        super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  final AuthenticationBloc _authenticationBloc;

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      _authenticationBloc.add(
        AuthenticationForgotPasswordRequested(email: state.email.value),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
