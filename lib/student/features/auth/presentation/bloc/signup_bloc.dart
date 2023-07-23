import 'package:Attendance_Monitor/student/features/auth/data/repositories/student_auth.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/bloc/signup_event.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/bloc/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignupEvent, SignupState> {
  SignUpBloc(
    this._studentAuthRepository,
  ) : super(const SignupState()) {
    on<SignupButtonPressedEvent>(_handleCreateAccountEvent);
    on<SignupNameChangedEvent>(_handleSignupNameChangedEvent);
    on<SignupClassIDChangedEvent>(_handleSignupClassIDChangedEvent);
    on<SignupEmailChangedEvent>(_handleSignupEmailChangedEvent);
    on<SignupDepartmentChangedEvent>(_handleSignupDepartmentChangedEvent);
    on<SignupGenderChangedEvent>(_handleSignupGenderChangedEvent);
    on<SignupDOBChangedEvent>(_handleSignupDOBChangedEvent);
    on<SignupPasswordChangedEvent>(_handleSignupPasswordChangedEvent);
    on<SignupConfirmPasswordChangedEvent>(_handleSignupConfirmPasswordChangedEvent);
  }
  final StudentAuthRepository _studentAuthRepository;

  Future<void> _handleSignupNameChangedEvent(
    SignupNameChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _handleSignupClassIDChangedEvent(
    SignupClassIDChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(classID: event.classID));
  }

  Future<void> _handleSignupEmailChangedEvent(
      SignupEmailChangedEvent event,
      Emitter<SignupState> emit,
      ) async {
    print(state.email);
    emit(state.copyWith(email: event.email));
  }

  Future<void> _handleSignupDepartmentChangedEvent(
      SignupDepartmentChangedEvent event,
    Emitter<SignupState> emit,
  ) async {
    print(state.department);
    emit(state.copyWith(department: event.department));
  }

  Future<void> _handleSignupGenderChangedEvent(
      SignupGenderChangedEvent event,
      Emitter<SignupState> emit,
      ) async {
    emit(state.copyWith(gender: event.gender));
  }

  Future<void> _handleSignupDOBChangedEvent(
      SignupDOBChangedEvent event,
      Emitter<SignupState> emit,
      ) async {

    emit(state.copyWith(dob: event.dob));
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
        state.dob.isNotEmpty &&
        state.name.isNotEmpty &&
        state.classID.isNotEmpty &&
        state.gender.isNotEmpty &&
        state.department.isNotEmpty &&
        state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty;


    if (isFieldEmpty) {
      try {
        if (state.confirmPassword == state.password) {
          emit(
              state.copyWith(message: 'Loading', status: SignupStatus.loading));
          await _studentAuthRepository.createUserWithEmailAndPassword(
            name: state.name,
            email: state.email,
            classID: state.classID,
            department: state.department,
            gender: state.gender,
            dob: state.dob,
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
