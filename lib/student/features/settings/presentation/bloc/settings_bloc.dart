import 'package:Attendance_Monitor/student/features/settings/data/models/settings_repository.dart';
import 'package:Attendance_Monitor/student/features/settings/presentation/bloc/settings_event.dart';
import 'package:Attendance_Monitor/student/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(
    this._repository,
  ) : super(const SettingsState()) {
    on<InitEvent>(_init);
  }

  final SettingsRepository _repository;

  Future<void> _init(InitEvent event, Emitter<SettingsState> emit) async {
    print("---------------SettingsBloc----------------");

    try {
      emit(state.copyWith(message: 'Loading', status: SettingsStatus.loading));
      final profileData = await _repository.fetchProfile();
      emit(state.copyWith(
        message: 'Success',
        status: SettingsStatus.success,
        name: profileData.name,
        classID: profileData.classID,
        department: profileData.department,
        dob: profileData.dob,
        email: profileData.email,
        gender: profileData.gender,
        imageUrl: profileData.imageUrl,
        studentID: profileData.studentID,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          message: e.toString(), status: SettingsStatus.failure));
    }
  }
}
