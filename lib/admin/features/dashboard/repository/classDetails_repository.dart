import 'package:Attendance_Monitor/admin/features/dashboard/bloc/classDetails_bloc/classDetails_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassDetailsRepository {
  Future<ClassDetailsState> fetchClass() async {
    try {
      final db = FirebaseFirestore.instance;
      // Obtain shared preferences.
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var data;

      final String? classID = prefs.getString('classID');

      print("classid = $classID");

      await db.collection("classes").doc(classID).get().then((doc) {
        print(doc);
        print("class doc = $doc");
        Map<String, dynamic> classDetails = doc.data()!;
        Timestamp it = classDetails['cit'];
        Timestamp ot = classDetails['cot'];
        String name = classDetails['name'];
        List<dynamic> days_ = classDetails['days'];
        List<String> days = days_.map((element) => element.toString()).toList();


        Map<String, dynamic> processedData = {
          "cit": DateFormat.jm().format(it.toDate()).toString(),
          "cot": DateFormat.jm().format(ot.toDate()).toString(),
          "name": name,
          "days": days,
          "classID": doc.id,
        };

        data = ClassDetailsState.fromJson(processedData);
      }).catchError((e) {
        throw Exception(e.toString());
      });
      return data;
    } catch (e) {
      throw (e.toString());
    }
  }
}
