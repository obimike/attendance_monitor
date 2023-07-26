import 'package:Attendance_Monitor/student/features/history/data/repositories/history_repository.dart';
import 'package:Attendance_Monitor/student/features/history/presentation/bloc/history_event.dart';
import 'package:Attendance_Monitor/student/features/history/presentation/bloc/history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc(
    this._repository,
  ) : super(const HistoryState()) {
    on<InitEvent>((event, emit) async {
      print("---------------HistoryBloc----------------");

      try {
        emit(state.copyWith(message: 'Loading', status: HistoryStatus.loading));
        final profileData = await _repository.fetchAttendance();

        emit(state.copyWith(
          message: 'Success',
          status: HistoryStatus.success,
          cit: profileData.cit,
          cot: profileData.cot,
          percentage: profileData.percentage,
        ));
      } catch (e) {
        print(e);
        emit(state.copyWith(
            message: "No attendance \nSorry you have attendance record for today!", status: HistoryStatus.failure));
      }
    });

    on<SelectDateEvent>((event, emit) async {
      print("---------------SelectDateEvent----------------");

      print(event.date);

      try {
        emit(state.copyWith(message: 'Loading', status: HistoryStatus.loading));
        final profileData = await _repository.fetchDateAttendance(event);

        emit(state.copyWith(
          message: 'Success',
          status: HistoryStatus.success,
          cit: profileData.cit,
          cot: profileData.cot,
          percentage: profileData.percentage,
        ));
      } catch (e) {
        print(e);
        emit(state.copyWith(
            message: "No attendance \nSorry you have attendance record for today!", status: HistoryStatus.failure));
      }
    });
  }

  final HistoryRepository _repository;
}
