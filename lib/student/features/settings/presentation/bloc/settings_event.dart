import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {}

class InitEvent extends SettingsEvent {
  InitEvent();

  @override
  List<Object> get props => [];
}
