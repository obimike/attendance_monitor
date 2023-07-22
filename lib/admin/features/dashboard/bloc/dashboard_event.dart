import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {}

class InitEvent extends DashboardEvent {
  InitEvent();

  @override
  List<Object> get props => [];
}


class LogOutButtonPressedEvent extends DashboardEvent {
  LogOutButtonPressedEvent();

  @override
  List<Object> get props => [];
}