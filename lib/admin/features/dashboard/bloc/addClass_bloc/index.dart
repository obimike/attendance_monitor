import 'package:Attendance_Monitor/admin/features/dashboard/bloc/addClass_bloc/addClass_event.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/addClass_bloc/addClass_state.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/repository/addClass_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClassBloc extends Bloc<AddClassEvent, AddClassState> {
  AddClassBloc(
    this._addClassRepository,
  ) : super(const AddClassState()) {
    on<ClassNameChangedEvent>(_handleNameChangedEvent);
    on<CheckInTimeChangedEvent>(_handleCITChangedEvent);
    on<DaysChangedEvent>(_handleDaysChangedEvent);
    on<CheckOutTimeChangedEvent>(_handleCOTChangedEvent);
    on<AddClassButtonPressedEvent>(_handleAddClassEvent);
  }

  final AddClassRepository _addClassRepository;

  Future<void> _handleNameChangedEvent(
    ClassNameChangedEvent event,
    Emitter<AddClassState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _handleCITChangedEvent(
    CheckInTimeChangedEvent event,
    Emitter<AddClassState> emit,
  ) async {
    emit(state.copyWith(cit: event.cit));
  }

  Future<void> _handleCOTChangedEvent(
    CheckOutTimeChangedEvent event,
    Emitter<AddClassState> emit,
  ) async {
    emit(state.copyWith(cot: event.cot));
  }

  Future<void> _handleDaysChangedEvent(
    DaysChangedEvent event,
    Emitter<AddClassState> emit,
  ) async {
    emit(state.copyWith(days: event.days));
  }

  Future<void> _handleAddClassEvent(
    AddClassButtonPressedEvent event,
    Emitter<AddClassState> emit,
  ) async {
    if (state.name.isNotEmpty &&
        state.days.isNotEmpty &&
        state.cot.isNotEmpty &&
        state.cit.isNotEmpty) {
      try {
        emit(
            state.copyWith(message: 'Loading', status: AddClassStatus.loading));
        await _addClassRepository.addClass(
          name: state.name,
          cit: state.cit,
          cot: state.cot,
          days: state.days,
        );

        emit(state.copyWith(
            message: 'Class Added Successfully',
            status: AddClassStatus.success));
      } catch (e) {
        emit(state.copyWith(
            message: e.toString(), status: AddClassStatus.failure));
      }
    } else {
      emit(state.copyWith(
          message: 'All fields are required!', status: AddClassStatus.failure));
    }
  }
}
