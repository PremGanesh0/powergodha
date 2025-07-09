import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:powergodha/login/models/password.dart';
import 'package:powergodha/login/models/phone_number.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginPhoneNumberChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: FormzSubmissionStatus.initial, // Reset the form status
        isValid: Formz.validate([password, state.phoneNumber]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final response = await _authenticationRepository.logIn(
          phoneNumber: state.phoneNumber.value,
          password: state.password.value,
        );
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          authResponse: response,
        ));
      } on AuthenticationException catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          error: e.message,
        ));
      }
    }
  }

  void _onUsernameChanged(
    LoginPhoneNumberChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = PhoneNumber.dirty(event.phoneNumber);
    emit(
      state.copyWith(
        phoneNumber: username,
        status: FormzSubmissionStatus.initial, // Reset the form status
        isValid: Formz.validate([state.password, username]),
      ),
    );
  }
}
