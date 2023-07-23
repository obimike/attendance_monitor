import 'package:Attendance_Monitor/admin/features/dashboard/data/studentList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentListRepository {
  Future<List<StudentListModel>> fetchStudents() async {
    List<StudentListModel> studentList = [];

    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? classID = prefs.getString('classID');
      final  db = await FirebaseFirestore.instance.collection("users").where("classID", isEqualTo: classID).get();

      db.docs.forEach((docSnapshot){
        return studentList.add(StudentListModel.fromJson(docSnapshot.data()));
      });

      return studentList;
    } catch (e) {
      throw (e.toString());
    }
  }
}
