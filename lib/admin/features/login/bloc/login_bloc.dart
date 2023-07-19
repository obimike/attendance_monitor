import 'package:Attendance_Monitor/admin/features/auth_service/auth.dart';
import 'package:Attendance_Monitor/admin/features/login/bloc/login_event.dart';
import 'package:Attendance_Monitor/admin/features/login/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(
    this._authService,
  ) : super(const LoginState()) {
    on<LoginButtonPressedEvent>(_handleLoginWithEmailAndPasswordEvent);
    on<LoginEmailChangedEvent>(_handleLoginEmailChangedEvent);
    on<LoginPasswordChangedEvent>(_handleLoginPasswordChangedEvent);
  }

  final AuthService _authService;

  Future<void> _handleLoginWithEmailAndPasswordEvent(
    LoginButtonPressedEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (state.email.isNotEmpty && state.password.isNotEmpty) {
      try {
        emit(state.copyWith(message: 'Loading', status: LoginStatus.loading));
        await _authService.signInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );

        emit(state.copyWith(message: 'Success', status: LoginStatus.success));
      } catch (e) {
        emit(
            state.copyWith(message: e.toString(), status: LoginStatus.failure));
      }
    } else {
      emit(state.copyWith(
          message: 'All fields are required!', status: LoginStatus.failure));
    }
  }

  Future<void> _handleLoginEmailChangedEvent(
    LoginEmailChangedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _handleLoginPasswordChangedEvent(
    LoginPasswordChangedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }
}
