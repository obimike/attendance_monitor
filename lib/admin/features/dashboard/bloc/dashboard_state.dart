import 'package:Attendance_Monitor/admin/features/dashboard/data/admin.dart';
import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  @override
  List<Object> get props => [];
}


class InitialState extends DashboardState {
  final Admin data;

  InitialState({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class LogOutState extends DashboardState {
  @override
  List<Object> get props => [];
}




