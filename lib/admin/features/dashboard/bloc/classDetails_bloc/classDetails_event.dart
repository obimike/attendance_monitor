import 'package:equatable/equatable.dart';

abstract class ClassDetailsEvent extends Equatable {}

class InitEvent extends ClassDetailsEvent {
  InitEvent();

  @override
  List<Object> get props => [];
}