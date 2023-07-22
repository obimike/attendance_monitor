import 'package:Attendance_Monitor/admin/features/dashboard/bloc/classDetails_bloc/classDetails_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassDetailsRepository {
  Future<ClassDetailsState> fetchClass() async {
    try {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;
      // Obtain shared preferences.
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var data;

      final String? classID = prefs.getString('classID');

      print("classid = $classID");

      await db.collection("classes").doc(classID).get().then((doc) {
        print(doc);
        print("class doc = $doc");

        var value = doc.data();

        value?["classID"] = doc.id;

        data = ClassDetailsState.fromJson(value!);
      }).catchError((e) {
        throw Exception(e.toString());
      });
      return data;
    } catch (e) {
      throw (e.toString());
    }
  }
}
