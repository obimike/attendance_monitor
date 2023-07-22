import 'package:Attendance_Monitor/admin/features/dashboard/bloc/classDetails_bloc/classDetails_event.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/classDetails_bloc/classDetails_state.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/repository/classDetails_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassDetailsBloc extends Bloc<ClassDetailsEvent, ClassDetailsState> {
  ClassDetailsBloc(
    this._classDetailsRepository,
  ) : super(const ClassDetailsState()) {
    on<InitEvent>(_init);
  }

  final ClassDetailsRepository _classDetailsRepository;

  Future<void> _init(InitEvent event, Emitter<ClassDetailsState> emit) async {
    print("---------------ClassDetailsBloc----------------");

    try {
      emit(state.copyWith(
          message: 'Loading', status: ClassDetailsStatus.loading));
      final classData = await _classDetailsRepository.fetchClass();
      emit(state.copyWith(
          message: 'Success',
          status: ClassDetailsStatus.success,
          name: classData.name,
          classID: classData.classID,
          cit: classData.cit,
          cot: classData.cot,
          days: classData.days));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          message: e.toString(), status: ClassDetailsStatus.failure));
    }
  }
}
