import 'package:Attendance_Monitor/admin/features/dashboard/data/admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardRepository {
  Future<Admin> fetchUserData() async {
    try {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      var _user;
      var admin;

      await auth.authStateChanges().listen((User? user) {
        if (user != null) {
          _user = user;
        }
      });

      await db.collection("admins").doc(_user.uid).get().then((doc) {
        print(Admin.fromJson(doc.data()!));
        admin = Admin.fromJson(doc.data()!);
      }).catchError((e) {
        throw Exception(e.toString());
      });
      return admin;
    } catch (e) {
      throw (e.toString());
    }
  }
}
