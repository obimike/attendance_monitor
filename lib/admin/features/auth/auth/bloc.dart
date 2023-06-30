import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<AuthState> emit) async {

  }
}
