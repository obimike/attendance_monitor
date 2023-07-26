import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentAuthRepository {
  Future<void> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String classID,
    required String department,
    required String dob,
    required String gender,
  }) async {
    try {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final dbRef = await db
          .collection("admins")
          .where("classID", isEqualTo: classID)
          .get()
          .then((value) {
        return value.size;
      });

      if (dbRef <= 0) {
        throw ('Invalid Class ID.');
      }

      final authRef = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final id = authRef.user?.uid;

      final user = <String, dynamic>{
        "name": name,
        "email": email,
        "classID": classID,
        "password": password,
        "gender": gender,
        "department": department,
        "dob": dob,
        "imageUrl": "",
        "studentID": id,
      };

      await authRef.user?.updateDisplayName(name);

      print(authRef.user?.uid);

      await db
          .collection("users")
          .doc(authRef.user?.uid)
          .set(user)
          .onError((e, _) => throw (e.toString()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        throw ('Invalid email address.');
      } else {
        throw (e.message.toString());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final db = await FirebaseFirestore.instance
          .collection("users")
          .where("studentID", isEqualTo: user.user?.uid)
          .get();

      if (db.docs.isNotEmpty) {
        Map<String, dynamic> userData = db.docs.first.data();
        String cID = userData['classID'];
        print(cID);


        await prefs.setString("classID", cID);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        throw ('Invalid email address.');
      } else {
        throw Exception(e.code);
      }
    } catch (e) {
      throw (e.toString());
    }
  }
}
