import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<DashboardState> emit) async {
    emit(state.clone());
  }
}
