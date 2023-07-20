import 'package:Attendance_Monitor/admin/features/auth_service/auth.dart';
import 'package:Attendance_Monitor/admin/features/signup/bloc/signup_event.dart';
import 'package:Attendance_Monitor/admin/features/signup/bloc/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc(
    this._authService,
  ) : super(const SignupState()) {
    on<SignupButtonPressedEvent>(_handleCreateAccountEvent);
    on<SignupFullNameChangedEvent>(_handleSignupFullNameChangedEvent);
    on<SignupEmailChangedEvent>(_handleSignupEmailChangedEvent);
    on<SignupAuthKeyChangedEvent>(_handleSignupAuthKeyChangedEvent);
    on<SignupDesignationChangedEvent>(_handleSignupDesignationChangedEvent);
    on<SignupPasswordChangedEvent>(_handleSignupPasswordChangedEvent);
    on<SignupConfirmPasswordChangedEvent>(
        _handleSignupConfirmPasswordChangedEvent);
  }

  final AuthService _authService;

  Future<void> _handleSignupFullNameChangedEvent(
    SignupFullNameChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(fullName: event.fullName));
  }

  Future<void> _handleSignupEmailChangedEvent(
    SignupEmailChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _handleSignupAuthKeyChangedEvent(
    SignupAuthKeyChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(authKey: event.authKey));
  }

  Future<void> _handleSignupDesignationChangedEvent(
    SignupDesignationChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(designation: event.designation));
  }

  Future<void> _handleSignupPasswordChangedEvent(
    SignupPasswordChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _handleSignupConfirmPasswordChangedEvent(
    SignupConfirmPasswordChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  Future<void> _handleCreateAccountEvent(
    SignupButtonPressedEvent event,
    Emitter<SignupState> emit,
  ) async {
    bool isFieldEmpty = state.email.isNotEmpty &&
        state.authKey.isNotEmpty &&
        state.fullName.isNotEmpty &&
        state.designation.isNotEmpty &&
        state.fullName.isNotEmpty &&
        state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty;

    if (isFieldEmpty) {
      try {
        if (state.confirmPassword == state.password) {
          emit(
              state.copyWith(message: 'Loading', status: SignupStatus.loading));
          await _authService.createUserWithEmailAndPassword(
            fullName: state.fullName,
            email: state.email,
            authKey: state.authKey,
            designation: state.designation,
            password: state.password,
          );

          emit(state.copyWith(status: SignupStatus.success));
        } else {
          emit(state.copyWith(
              message: 'Password do not match!', status: SignupStatus.failure));
        }
      } catch (e) {
        emit(state.copyWith(
            message: e.toString(), status: SignupStatus.failure));
      }
    } else {
      emit(state.copyWith(
          message: 'All fields are required!', status: SignupStatus.failure));
    }
  }
}
