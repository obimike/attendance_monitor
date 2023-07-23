import 'dart:convert';

List<StudentListModel> studentListModelFromJson(String str) =>
    List<StudentListModel>.from(
        json.decode(str).map((x) => StudentListModel.fromJson(x)));

class StudentListModel {
  const StudentListModel({
    required this.name,
    required this.gender,
    required this.department,
    required this.email,
    required this.dob,
    required this.imageUrl,
    required this.studentID,
  });

  final String name;
  final String gender;
  final String department;
  final String email;
  final String dob;
  final String imageUrl;
  final String studentID;

  factory StudentListModel.fromJson(Map<String, dynamic> data) =>
      StudentListModel(
        name: data['name'],
        gender: data['gender'],
        department: data['department'],
        email: data['email'],
        dob: data['dob'],
        imageUrl: data['imageUrl'],
        studentID: data['studentID'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "gender": gender,
        "email": email,
        "department": department,
        "dob": dob,
        "imageUrl": imageUrl,
        "studentID": studentID,
      };
}
