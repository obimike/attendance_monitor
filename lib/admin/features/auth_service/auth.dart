import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final db = FirebaseFirestore.instance;
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await db.collection("admins").doc(user.user?.uid).get().then((doc) {
        Map<String, dynamic>? data = doc.data();
        var value = data?['role'];
        if (value == null) {
          FirebaseAuth.instance.signOut();
          throw ('Sorry, You are not an administrator.');
        }
      });
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

  Future<void> createUserWithEmailAndPassword(
      {required String fullName,
      required String email,
      required String password,
      required String authKey,
      required String designation}) async {
    final user = <String, dynamic>{
      "fullName": fullName,
      "email": email,
      "authKey": authKey,
      "designation": designation,
      "role": "admin",
      "displayImage": "",
      "hasClass": false,
      "classID": "",
    };

    try {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final dbRef = await db
          .collection("authorization")
          .where("keys", arrayContains: authKey)
          .get()
          .then((value) {
        return value.size;
      });

      if (dbRef <= 0) {
        throw ('Invalid Authorization Key.');
      }

      final authRef = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final id = authRef.user?.uid;

      await authRef.user?.updateDisplayName(fullName);

      await db
          .collection("admins")
          .doc(id)
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
        throw Exception(e.code);
      }
    } catch (e) {
      throw (e.toString());
    }
  }
}
