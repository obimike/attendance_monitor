

import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class SignupButtonPressedEvent extends SignupEvent {
  const SignupButtonPressedEvent();
}

class SignupFullNameChangedEvent extends SignupEvent {
  const SignupFullNameChangedEvent({required this.fullName});

  final String fullName;

  @override
  List<Object> get props => [fullName];
}

class SignupAuthKeyChangedEvent extends SignupEvent {
  const SignupAuthKeyChangedEvent({required this.authKey});

  final String authKey;

  @override
  List<Object> get props => [authKey];
}

class SignupEmailChangedEvent extends SignupEvent {
  const SignupEmailChangedEvent({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class SignupDesignationChangedEvent extends SignupEvent {
  const SignupDesignationChangedEvent({required this.designation});

  final String designation;

  @override
  List<Object> get props => [designation];
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