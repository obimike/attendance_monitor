import 'package:Attendance_Monitor/student/features/history/presentation/bloc/history_event.dart';
import 'package:Attendance_Monitor/student/features/history/presentation/bloc/history_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  Future<HistoryState> fetchAttendance() async {
    try {
      var data;
      final userid = await FirebaseAuth.instance.currentUser?.uid;
      print(userid);
      final db = await FirebaseFirestore.instance
          .collection("attendance")
          .where("studentID", isEqualTo: userid)
          .get();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? classID = prefs.getString('classID');

      print("classid = $classID");

      final fetchClass = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classID)
          .get();

      if (db.docs.isNotEmpty && fetchClass.data()!.isNotEmpty) {
        //Getting class details
        Map<String, dynamic> classDoc = fetchClass.data()!;
        Timestamp cit = classDoc['cit'];
        Timestamp cot = classDoc['cot'];
        // List<String> days = classDoc['days'];

        String _cit = DateFormat.jm().format(cit.toDate()).toString();
        String _cot = DateFormat.jm().format(cot.toDate()).toString();

        String citStrings = _cit.replaceAll(":", ".");
        citStrings = citStrings.replaceAll(" AM", "");
        citStrings = citStrings.replaceAll(" PM", "");

        String cotStrings = _cot.replaceAll(":", ".");
        cotStrings = cotStrings.replaceAll(" AM", "");
        cotStrings = cotStrings.replaceAll(" PM", "");

        double citValue = double.parse(citStrings);
        double cotValue = double.parse(cotStrings);

        double classTimeDiff = cotValue - citValue;

        print("classTimeDiff $classTimeDiff");

        //fetching attendances
        for (var docSnapshot in db.docs) {
          Map<String, dynamic> _doc = docSnapshot.data();
          Timestamp dt = _doc['date'];

          DateTime today = DateTime.now();

          var todayDate = DateFormat.yMd().format(today);
          var setDate = DateFormat.yMd().format(dt.toDate());

          // print("$todayDate format today");
          // print("$setDate _format today");

          if (todayDate == setDate) {
            Map<String, dynamic> todayData = docSnapshot.data();
            print("------if is true-------");
            Timestamp it = todayData['cit'];
            Timestamp ot = todayData['cot'];

            print("ot $ot");

            String cit_ = DateFormat.jm().format(it.toDate()).toString();
            String cot_ = DateFormat.jm().format(ot.toDate()).toString();

            print("cot_ $cot_");

            String citStrings_ = cit_.replaceAll(":", ".");
            citStrings_ = citStrings_.replaceAll(" AM", "");
            citStrings_ = citStrings_.replaceAll(" PM", "");

            String cotStrings_ = cot_.replaceAll(":", ".");
            cotStrings_ = cotStrings_.replaceAll(" AM", "");
            cotStrings_ = cotStrings_.replaceAll(" PM", "");

            double citValue_ = double.parse(citStrings_);
            double cotValue_ = double.parse(cotStrings_);

            double attendanceTimeDiff = cotValue_ - citValue_;
            print("cotValue_ $cotValue_");

            print("attendanceTimeDiff $attendanceTimeDiff");

            double percentile = (attendanceTimeDiff / classTimeDiff);

            var percentage = NumberFormat('##0.#', 'en_US');
            print(percentage.format(percentile));

            Map<String, dynamic> processedData = {
              "cit": DateFormat.jm().format(it.toDate()).toString(),
              "cot": DateFormat.jm().format(ot.toDate()).toString(),
              "percentage": percentage.format(percentile),
            };

            data = HistoryState.fromJson(processedData);
          }
        }
      } else {
        throw ("No attendance \nSorry you have attendance record for today!");
      }

      return data;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<HistoryState> fetchDateAttendance(SelectDateEvent event) async  {
    try {
      var data;
      final userid = await FirebaseAuth.instance.currentUser?.uid;
      print(userid);
      final db = await FirebaseFirestore.instance
          .collection("attendance")
          .where("studentID", isEqualTo: userid)
          .get();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? classID = prefs.getString('classID');

      print("classid = $classID");

      final fetchClass = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classID)
          .get();

      if (db.docs.isNotEmpty && fetchClass.data()!.isNotEmpty) {
        //Getting class details
        Map<String, dynamic> classDoc = fetchClass.data()!;
        Timestamp cit = classDoc['cit'];
        Timestamp cot = classDoc['cot'];
        // List<String> days = classDoc['days'];

        String _cit = DateFormat.jm().format(cit.toDate()).toString();
        String _cot = DateFormat.jm().format(cot.toDate()).toString();

        String citStrings = _cit.replaceAll(":", ".");
        citStrings = citStrings.replaceAll(" AM", "");
        citStrings = citStrings.replaceAll(" PM", "");

        String cotStrings = _cot.replaceAll(":", ".");
        cotStrings = cotStrings.replaceAll(" AM", "");
        cotStrings = cotStrings.replaceAll(" PM", "");

        double citValue = double.parse(citStrings);
        double cotValue = double.parse(cotStrings);

        double classTimeDiff = cotValue - citValue;

        print("classTimeDiff $classTimeDiff");

        //fetching attendances
        for (var docSnapshot in db.docs) {
          Map<String, dynamic> _doc = docSnapshot.data();
          Timestamp dt = _doc['date'];

          DateTime today = DateTime.now();

          var todayDate = DateFormat.yMd().format(event.date);
          var setDate = DateFormat.yMd().format(dt.toDate());

          // print("$todayDate format today");
          // print("$setDate _format today");

          if (todayDate == setDate) {
            Map<String, dynamic> todayData = docSnapshot.data();
            print("------if is true-------");
            Timestamp it = todayData['cit'];
            Timestamp ot = todayData['cot'];

            print("ot $ot");

            String cit_ = DateFormat.jm().format(it.toDate()).toString();
            String cot_ = DateFormat.jm().format(ot.toDate()).toString();

            print("cot_ $cot_");

            String citStrings_ = cit_.replaceAll(":", ".");
            citStrings_ = citStrings_.replaceAll(" AM", "");
            citStrings_ = citStrings_.replaceAll(" PM", "");

            String cotStrings_ = cot_.replaceAll(":", ".");
            cotStrings_ = cotStrings_.replaceAll(" AM", "");
            cotStrings_ = cotStrings_.replaceAll(" PM", "");

            double citValue_ = double.parse(citStrings_);
            double cotValue_ = double.parse(cotStrings_);

            double attendanceTimeDiff = cotValue_ - citValue_;
            print("cotValue_ $cotValue_");

            print("attendanceTimeDiff $attendanceTimeDiff");

            double percentile = (attendanceTimeDiff / classTimeDiff);

            var percentage = NumberFormat('##0.###', 'en_US');
            print(percentage.format(percentile));

            Map<String, dynamic> processedData = {
              "cit": DateFormat.jm().format(it.toDate()).toString(),
              "cot": DateFormat.jm().format(ot.toDate()).toString(),
              "percentage": percentage.format(percentile),
            };

            data = HistoryState.fromJson(processedData);
          }
        }
      } else {
        throw ("No attendance \nSorry you have attendance record for today!");
      }

      return data;
    } catch (e) {
      throw (e.toString());
    }
  }
}
