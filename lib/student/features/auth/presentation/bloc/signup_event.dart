import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class SignupButtonPressedEvent extends SignupEvent {
  const SignupButtonPressedEvent();
}

class SignupNameChangedEvent extends SignupEvent {
  const SignupNameChangedEvent({required this.name});
  final String name;
  @override
  List<Object> get props => [name];
}

class SignupClassIDChangedEvent extends SignupEvent {
  const SignupClassIDChangedEvent({required this.classID});
  final String classID;
  @override
  List<Object> get props => [classID];
}

class SignupDepartmentChangedEvent extends SignupEvent {
  const SignupDepartmentChangedEvent({required this.department});
  final String department;
  @override
  List<Object> get props => [department];
}

class SignupEmailChangedEvent extends SignupEvent {
  const SignupEmailChangedEvent({required this.email});
  final String email;
  @override
  List<Object> get props => [email];
}

class SignupGenderChangedEvent extends SignupEvent {
  const SignupGenderChangedEvent({required this.gender});
  final String gender;
  @override
  List<Object> get props => [gender];
}


class SignupDOBChangedEvent extends SignupEvent {
  const SignupDOBChangedEvent({required this.dob});
  final String dob;
  @override
  List<Object> get props => [dob];
}

class SignupPasswordChangedEvent extends SignupEvent {
  const SignupPasswordChangedEvent({required this.password});
  final String password;
  @override
  List<Object> get props => [password];
}

class SignupConfirmPasswordChangedEvent extends SignupEvent {
  const SignupConfirmPasswordChangedEvent({required this.confirmPassword});
  final String confirmPassword;
  @override
  List<Object> get props => [confirmPassword];
}