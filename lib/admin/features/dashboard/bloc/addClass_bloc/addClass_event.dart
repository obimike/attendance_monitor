import 'package:equatable/equatable.dart';

abstract class AddClassEvent extends Equatable {}

class ClassNameChangedEvent extends AddClassEvent {
  ClassNameChangedEvent({required this.name});
  final String name;
  @override
  List<Object> get props => [name];
}

class CheckInTimeChangedEvent extends AddClassEvent {
  CheckInTimeChangedEvent({required this.cit});
  final DateTime cit;
  @override
  List<Object> get props => [cit];
}

class CheckOutTimeChangedEvent extends AddClassEvent {
  CheckOutTimeChangedEvent({required this.cot});
  final DateTime cot;
  @override
  List<Object> get props => [cot];
}

class DaysChangedEvent extends AddClassEvent {
  DaysChangedEvent({required this.days});
  final List<dynamic> days;
  @override
  List<Object> get props => [days];
}

class AddClassButtonPressedEvent extends AddClassEvent {
  AddClassButtonPressedEvent();

  @override
  List<Object> get props => [];
}