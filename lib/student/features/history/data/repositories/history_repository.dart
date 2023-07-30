import 'package:Attendance_Monitor/student/features/history/presentation/bloc/history_event.dart';
import 'package:Attendance_Monitor/student/features/history/presentation/bloc/history_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  Future<HistoryState> fetchAttendance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var data;
      final userid = await FirebaseAuth.instance.currentUser?.uid;
      print(userid);
      final db = await FirebaseFirestore.instance
          .collection("attendance")
          .where("studentID", isEqualTo: userid)
          .get();

      final String? classID = prefs.getString('classID');

      print("classid = $classID");

      final fetchClass = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classID)
          .get();

      if (fetchClass.data()!.isNotEmpty) {
        Map<String, dynamic> _classDoc = fetchClass.data()!;
        Timestamp cit = _classDoc['cit'];
        Timestamp cot = _classDoc['cot'];
        List<dynamic> days_ = _classDoc['days'];
        List<String> days = days_.map((element) => element.toString()).toList();
        String adminName = _classDoc['adminName'];
        String name = _classDoc['name'];

        String _cit_ = DateFormat.jm().format(cit.toDate()).toString();
        String _cot_ = DateFormat.jm().format(cot.toDate()).toString();

        prefs.setString("classCit", _cit_);
        prefs.setString("classCot", _cot_);
        prefs.setString("adminName", adminName);
        prefs.setStringList("classDays", days);
        prefs.setString("className", name);

        prefs.setString("classCotTimestamp", cot.toDate().toString());
        prefs.setString("classCitTimestamp", cit.toDate().toString());
      }

      if (db.docs.isNotEmpty && fetchClass.data()!.isNotEmpty) {
        //Getting class details
        Map<String, dynamic> classDoc = fetchClass.data()!;
        Timestamp classCit_ = classDoc['cit'];
        Timestamp classCot_ = classDoc['cot'];

        List<DateTime> classCitList = [];
        List<DateTime> classCotList = [];

        classCitList.add(classCit_.toDate());
        classCotList.add(classCot_.toDate());

        double citValue = convertAverageDateTimeToNumber(classCitList);
        double cotValue = convertAverageDateTimeToNumber(classCotList);

        double classTimeDiff = cotValue - citValue;



        List<DateTime> citList = [];
        List<DateTime> cotList = [];
        List<DateTime> citList_ = [];
        List<DateTime> cotList_ = [];

        //fetching attendances
        for (var docSnapshot in db.docs) {
          Timestamp it = docSnapshot['cit'];
          Timestamp ot = docSnapshot['cot'];
          Timestamp attendanceDate = docSnapshot['date'];

          DateTime cit = it.toDate();
          DateTime cot = ot.toDate();

          citList.add(cit);
          cotList.add(cot);

          var setDate = DateFormat.yMd().format(attendanceDate.toDate());
          var todayDate = DateFormat.yMd().format(DateTime.now());


          if (todayDate == setDate) {
            Timestamp it_ = docSnapshot['cit'];
            Timestamp ot_ = docSnapshot['cot'];

            DateTime cit_ = it_.toDate();
            DateTime cot_ = ot_.toDate();

            print("setDate $setDate");

            citList_.add(cit_);
            cotList_.add(cot_);

          }
        }

        String cit_ = DateFormat.jm()
            .format(calculateAverageDateTime(citList))
            .toString();
        String cot_ = DateFormat.jm()
            .format(calculateAverageDateTime(cotList))
            .toString();

        double citValue_ = convertAverageDateTimeToNumber(citList_);
        double cotValue_ = convertAverageDateTimeToNumber(cotList_);

        double attendanceTimeDiff = cotValue_ - citValue_;

        print("attendanceTimeDiff $attendanceTimeDiff");

        double percentile = (attendanceTimeDiff / classTimeDiff);
        var percentage = NumberFormat('##.0##', 'en_US');

        print(percentage.format(percentile));

        //store in shared preferences
        prefs.setBool("hasAttended", true);

        Map<String, dynamic> processedData = {
          "cit": cit_,
          "cot": cot_,
          "percentage": percentage.format(percentile),
        };
        data = HistoryState.fromJson(processedData);


      } else {
        throw ("No attendance \nSorry you have attendance record for today!");
      }

      return data;
    } catch (e) {
      prefs.setBool("hasAttended", false);
      throw (e.toString());
    }
  }

  Future<HistoryState> fetchDateAttendance(SelectDateEvent event) async {
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
        Map<String, dynamic> classDoc_ = fetchClass.data()!;
        Timestamp classCit_ = classDoc_['cit'];
        Timestamp classCot_ = classDoc_['cot'];

        var todayDate = DateFormat.yMd().format(event.date);

        List<DateTime> classCitList = [];
        List<DateTime> classCotList = [];

        classCitList.add(classCit_.toDate());
        classCotList.add(classCot_.toDate());

        double citValue = convertAverageDateTimeToNumber(classCitList);
        double cotValue = convertAverageDateTimeToNumber(classCotList);

        double classTimeDiff = cotValue - citValue;

        List<DateTime> citList = [];
        List<DateTime> cotList = [];
        List<DateTime> citList_ = [];
        List<DateTime> cotList_ = [];
        //fetching attendances
        for (var docSnapshot in db.docs) {
          Timestamp it = docSnapshot['cit'];
          Timestamp ot = docSnapshot['cot'];
          Timestamp attendanceDate = docSnapshot['date'];

          DateTime cit = it.toDate();
          DateTime cot = ot.toDate();

          citList.add(cit);
          cotList.add(cot);

          var setDate = DateFormat.yMd().format(attendanceDate.toDate());

          if (todayDate == setDate) {
            Timestamp it_ = docSnapshot['cit'];
            Timestamp ot_ = docSnapshot['cot'];

            DateTime cit_ = it_.toDate();
            DateTime cot_ = ot_.toDate();

            print("setDate $setDate");

            citList_.add(cit_);
            cotList_.add(cot_);

          }
        }


        String cit_ = DateFormat.jm()
            .format(calculateAverageDateTime(citList))
            .toString();
        String cot_ = DateFormat.jm()
            .format(calculateAverageDateTime(cotList))
            .toString();

        double citValue_ = convertAverageDateTimeToNumber(citList_);
        double cotValue_ = convertAverageDateTimeToNumber(cotList_);

        double attendanceTimeDiff = cotValue_ - citValue_;

        print("attendanceTimeDiff $attendanceTimeDiff");

        double percentile = (attendanceTimeDiff / classTimeDiff);
        var percentage = NumberFormat('##.0##', 'en_US');

        print(percentage.format(percentile));

        //store in shared preferences
        prefs.setBool("hasAttended", true);

        Map<String, dynamic> processedData = {
          "cit": cit_,
          "cot": cot_,
          "percentage": percentage.format(percentile),
        };
        data = HistoryState.fromJson(processedData);

      } else {
        throw ("No attendance \nSorry you have attendance record for today!");
      }

      return data;
    } catch (e) {
      throw (e.toString());
    }
  }


  DateTime calculateAverageDateTime(List<DateTime> dateTimeList) {
    if (dateTimeList.isEmpty) {
      return DateTime.now(); // Return the current DateTime if the list is empty
    }

    int totalMinutes = 0;

    for (DateTime dateTime in dateTimeList) {
      totalMinutes += dateTime.hour * 60 + dateTime.minute;
    }
    int averageMinutes = totalMinutes ~/ dateTimeList.length;

    int averageHour = averageMinutes ~/ 60;
    int averageMinute = averageMinutes % 60;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, averageHour, averageMinute);
  }

  double convertAverageDateTimeToNumber(List<DateTime> dateTimeList) {
    if (dateTimeList.isEmpty) {
      throw ("List can not be empty."); // Return the current DateTime if the list is empty
    }

    int totalMinutes = 0;

    for (DateTime dateTime in dateTimeList) {
      totalMinutes += dateTime.hour * 60 + dateTime.minute;
    }

    return totalMinutes / dateTimeList.length;
  }

}
