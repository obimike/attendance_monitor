import 'package:equatable/equatable.dart';

abstract class StudentListEvent extends Equatable {}

class InitEvent extends StudentListEvent {
  InitEvent();

  @override
  List<Object> get props => [];
}