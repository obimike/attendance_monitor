import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddClassRepository {
  Future<void> addClass(
      {required String name,
      required String cit,
      required String cot,
      required List<dynamic> days}) async {
    try {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;
      auth.authStateChanges().listen((User? user) {
        if (user != null) {
          print(user.uid);
          final data = <String, dynamic>{
            "name": name,
            "cit": cit,
            "cot": cot,
            "days": days,
            "adminName": user.displayName,
            "adminEmail": user.email,
            "adminID": user.uid,
          };

          db.collection("classes").add(data).then((doc) {
            db
                .collection("admins")
                .doc(user.uid)
                .update({"hasClass": true, "classID": doc.id});
          }).onError((e, _) => throw (e.toString()));
        }
      });
    } catch (e) {
      throw (e.toString());
    }
  }
}
