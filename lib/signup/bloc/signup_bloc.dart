import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:powergodha/login/models/models.dart';
import 'package:powergodha/signup/models/name.dart';
import 'package:powergodha/signup/models/phone_number.dart' as signup_models;

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const SignupState()) {
    on<SignupNameChanged>(_onNameChanged);
    on<SignupPhoneNumberChanged>(_onPhoneNumberChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onNameChanged(SignupNameChanged event,
    Emitter<SignupState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([
          name, state.phoneNumber,
          state.password,
        ]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onPasswordChanged(SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([
          state.name, state.phoneNumber, password,
        ]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onPhoneNumberChanged(SignupPhoneNumberChanged event,
    Emitter<SignupState> emit,
  ) {
    final phoneNumber = signup_models.PhoneNumber.dirty(event.phoneNumber);
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        isValid: Formz.validate([
          state.name,
          phoneNumber, state.password,
        ]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final response = await _authenticationRepository.signUp(
          name: state.name.value,
          phoneNumber: state.phoneNumber.value,
          password: state.password.value,
        );
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          registrationResponse: response,
        ));
      } on AuthenticationException catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          error: e.message,
        ));
      }
    }
  }
}
