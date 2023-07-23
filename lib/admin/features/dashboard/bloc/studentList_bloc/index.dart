import 'package:Attendance_Monitor/admin/features/dashboard/bloc/studentList_bloc/studentList_event.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/studentList_bloc/studentList_state.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/repository/studentList_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListBloc extends Bloc<StudentListEvent, StudentListState> {
  StudentListBloc(
    this._studentListRepository,
  ) : super(const StudentListState()) {
    on<InitEvent>(_init);
  }

  final StudentListRepository _studentListRepository;

  Future<void> _init(InitEvent event, Emitter<StudentListState> emit) async {
    print("---------------StudentListBloc----------------");

    try {
      emit(state.copyWith(
          message: 'Loading', status: StudentListStatus.loading));
      final classData = await _studentListRepository.fetchStudents();
      // emit(state.copyWith(
      //     message: 'Success',
      //     status: StudentListStatus.success,
      //     name: classData.name,
      //     gender: classData.gender,
      //     email: classData.email,
      //     dob: classData.dob,
      //     imageUrl: classData.imageUrl,
      //     department: classData.department));
      emit(state.copyWith(
        message: 'Success',
        status: StudentListStatus.success,
        studentListModel: classData,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          message: e.toString(), status: StudentListStatus.failure));
    }
  }
}
