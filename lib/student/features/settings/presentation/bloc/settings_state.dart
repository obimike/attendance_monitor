import 'package:equatable/equatable.dart';

enum SettingsStatus {
  success,
  failure,
  loading,
}

class SettingsState extends Equatable {
  const SettingsState({
    this.message = '',
    this.status = SettingsStatus.loading,
    this.name = '',
    this.department = '',
    this.dob = '',
    this.email = '',
    this.classID = '',
    this.gender = '',
    this.imageUrl = '',
    this.studentID = '',
  });

  final String message;
  final SettingsStatus status;
  final String name;
  final String department;
  final String dob;
  final String email;
  final String? classID;
  final String gender;
  final String imageUrl;
  final String? studentID;

  factory SettingsState.fromJson(Map<String, dynamic> data) => SettingsState(
    name: data['name'],
    department: data['department'],
    email: data['email'],
    dob: data['dob'],
    classID: data['classID'],
    gender: data['gender'],
    imageUrl: data['imageUrl'],
    studentID: data['studentID'],
  );

  SettingsState copyWith({
    String? name,
    String? department,
    String? dob,
   String? email,
    SettingsStatus? status,
    String? message,
    String? classID,
    String? gender,
    String? imageUrl,
    String? studentID,
  }) {
    return SettingsState(
      name: name ?? this.name,
      department: department ?? this.department,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      status: status ?? this.status,
      message: message ?? this.message,
      classID: classID ?? this.classID,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
      studentID: studentID ?? this.studentID,
    );
  }

  @override
  List<Object?> get props => [
    message,
    status,
    name,
    department,
    dob,
    email,
    classID,
    gender,
    imageUrl,
    studentID
  ];
}
