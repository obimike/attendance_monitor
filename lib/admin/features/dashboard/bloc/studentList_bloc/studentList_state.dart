import 'package:Attendance_Monitor/admin/features/dashboard/data/studentList.dart';
import 'package:equatable/equatable.dart';

enum StudentListStatus {
  success,
  failure,
  loading,
}

class StudentListState extends Equatable {
  const StudentListState({
    this.message = '',
    this.status = StudentListStatus.loading,
    this.studentListModel = const[],
  });

  final String message;
  final StudentListStatus status;
  final List<StudentListModel> studentListModel;

  StudentListState copyWith({
    List<StudentListModel>? studentListModel,
    StudentListStatus? status,
    String? message,
  }) {
    return StudentListState(
      status: status ?? this.status,
      message: message ?? this.message,
      studentListModel: studentListModel ?? this.studentListModel,
    );
  }

  @override
  List<Object?> get props => [
    message,
    status,
    studentListModel,
  ];
}
