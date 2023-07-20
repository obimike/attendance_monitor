import 'package:equatable/equatable.dart';

enum SignupStatus {
  success,
  failure,
  loading,
  initial,
}

class SignupState extends Equatable {
  const SignupState({
    this.fullName = '',
    this.email = '',
    this.authKey = '',
    this.designation = '',
    this.password = '',
    this.confirmPassword = '',
    this.message = '',
    this.status = SignupStatus.initial,
  });

  final String message;
  final SignupStatus status;
  final String fullName;
  final String authKey;
  final String email;
  final String password;
  final String designation;
  final String confirmPassword;

  SignupState copyWith({
    String? fullName,
    String? authKey,
    String? email,
    String? password,
    String? designation,
    String? confirmPassword,
    SignupStatus? status,
    String? message,
  }) {
    return SignupState(
      fullName: fullName ?? this.fullName,
      authKey: authKey ?? this.authKey,
      email: email ?? this.email,
      designation: designation ?? this.designation,
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
        fullName,
        authKey,
        designation,
        email,
        password,
        confirmPassword,
      ];
}
