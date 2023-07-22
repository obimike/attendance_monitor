import 'package:equatable/equatable.dart';

enum ClassDetailsStatus {
  success,
  failure,
  loading,
}

class ClassDetailsState extends Equatable {
  const ClassDetailsState({
    this.message = '',
    this.status = ClassDetailsStatus.loading,
    this.name = '',
    this.cit = '',
    this.cot = '',
    this.days = const[],
    this.classID = '',
  });

  final String message;
  final ClassDetailsStatus status;
  final String name;
  final String cit;
  final String cot;
  final List<dynamic> days;
  final String? classID;

  factory ClassDetailsState.fromJson(Map<String, dynamic> data) => ClassDetailsState(
    name: data['name'],
    cit: data['cit'],
    days: data['days'],
    cot: data['cot'],
    classID: data['classID'],
  );

  ClassDetailsState copyWith({
    String? name,
    String? cit,
    String? cot,
    List<dynamic>? days,
    ClassDetailsStatus? status,
    String? message,
    String? classID,
  }) {
    return ClassDetailsState(
      name: name ?? this.name,
      cit: cit ?? this.cit,
      cot: cot ?? this.cot,
      days: days ?? this.days,
      status: status ?? this.status,
      message: message ?? this.message,
      classID: classID ?? this.classID,
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
    classID
  ];
}
