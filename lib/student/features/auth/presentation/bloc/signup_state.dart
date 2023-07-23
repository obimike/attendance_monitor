import 'package:equatable/equatable.dart';

enum SignupStatus {
  success,
  failure,
  loading,
  initial,
}

class SignupState extends Equatable {
  const SignupState({
    this.name = '',
    this.email = '',
    this.classID = '',
    this.department = '',
    this.dob = '',
    this.gender = '',
    this.password = '',
    this.confirmPassword = '',
    this.message = '',
    this.status = SignupStatus.initial,
  });

  final String message;
  final SignupStatus status;
  final String name;
  final String classID;
  final String email;
  final String department;
  final String dob;
  final String gender;
  final String password;
  final String confirmPassword;

  SignupState copyWith({
    String? name,
    String? classID,
    String? email,
    String? password,
    String? gender,
    String? department,
    String? dob,
    String? confirmPassword,
    SignupStatus? status,
    String? message,
  }) {
    return SignupState(
      name: name ?? this.name,
      classID: classID ?? this.classID,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      department: department ?? this.department,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        message,
        status,
        name,
        gender,
        classID,
        department,
        email,
        dob,
        password,
        confirmPassword,
      ];
}
