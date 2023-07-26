import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {}

class InitEvent extends HistoryEvent {
  InitEvent();
  @override
  List<Object> get props => [];
}

class SelectDateEvent extends HistoryEvent {
  SelectDateEvent({required this.date});
  final DateTime date;
  @override
  List<Object> get props => [date];
}
