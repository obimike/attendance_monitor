import 'package:Attendance_Monitor/student/features/settings/presentation/bloc/settings_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsRepository {
  Future<SettingsState> fetchProfile() async {
    try {
      final db = FirebaseFirestore.instance;
      final userid = await FirebaseAuth.instance.currentUser?.uid;
      var data;

      await db.collection("users").doc(userid).get().then((doc) {
        print("users doc = $doc");

        data = SettingsState.fromJson(doc.data()!);
      }).catchError((e) {
        throw Exception(e.toString());
      });
      return data;
    } catch (e) {
      throw (e.toString());
    }
  }
}
