import 'package:equatable/equatable.dart';

abstract class AuthEvent  extends Equatable {}

class InitEvent extends AuthEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}