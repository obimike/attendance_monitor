import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<DashboardState> emit) async {
    emit(state.clone());
  }
}
