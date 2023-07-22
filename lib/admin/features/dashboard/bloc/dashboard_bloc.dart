import 'package:Attendance_Monitor/admin/features/dashboard/repository/dashboard_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(
    this._dashboardRepository,
  ) : super(DashboardState()) {
    on<InitEvent>(_init);
    on<LogOutButtonPressedEvent>((event, emit) {
      FirebaseAuth.instance.signOut();
      emit(LogOutState());
    });
  }

  final DashboardRepository _dashboardRepository;

  Future<void> _init(InitEvent event, Emitter<DashboardState> emit) async {
    print("What-------------------------------");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final userData = await _dashboardRepository.fetchUserData();
      // await _dashboardRepository.fetchUserData();
      await prefs.setBool("hasClass", userData.hasClass!);
      emit(InitialState(data: userData));
    } catch (e) {
      print(e);
    }
  }
}
