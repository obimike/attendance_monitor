import 'package:equatable/equatable.dart';

enum AddClassStatus {
  success,
  failure,
  loading,
  initial,
}

class AddClassState extends Equatable {
  const AddClassState({
    this.message = '',
    this.status = AddClassStatus.initial,
    this.name = '',
    this.cit = '',
    this.cot = '',
    this.days = const[],
  });

  final String message;
  final AddClassStatus status;
  final String name;
  final String cit;
  final String cot;
  final List<dynamic> days;

  AddClassState copyWith({
    String? name,
    String? cit,
    String? cot,
    List<dynamic>? days,
    AddClassStatus? status,
    String? message,
  }) {
    return AddClassState(
      name: name ?? this.name,
      cit: cit ?? this.cit,
      cot: cot ?? this.cot,
      days: days ?? this.days,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        message,
        status,
        name,
        cit,
        cot,
        days,
      ];
}
