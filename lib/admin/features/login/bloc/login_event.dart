import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class LoginEmailChangedEvent extends LoginEvent {
  LoginEmailChangedEvent({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginPasswordChangedEvent extends LoginEvent {
  LoginPasswordChangedEvent({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginButtonPressedEvent extends LoginEvent {
   LoginButtonPressedEvent();

   @override
   List<Object> get props => [];
}