import 'package:Attendance_Monitor/admin/features/dashboard/data/studentList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Student extends StatefulWidget {
  final StudentListModel user;

  const Student({required this.user, super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  bool isLoading = true;
  bool hasResult = false;
  String averageCit = '';
  String averageCot = '';
  String percentage = "0.0";

  void sendEmail() async {
    String email = Uri.encodeComponent(widget.user.email);
    Uri mail = Uri.parse("mailto:$email?subject=''&body=''");
    await launchUrl(mail);
  }

  @override
  void initState() {
    _getAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Profile",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.start,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 90,
                  foregroundImage:
                      NetworkImage(widget.user.imageUrl.toString()),
                  backgroundImage: const AssetImage('images/user.png'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.user.name,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              Text(
                widget.user.email,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
              Text(
                widget.user.department,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
              Text(
                widget.user.gender,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
              Text(
                widget.user.dob,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Overall Attendance Stat",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 16),
              isLoading ? const SizedBox(
                height: 240,
                child: Center(
                  child: SizedBox(
                    height: 64,
                    width: 64,
                    child: CircularProgressIndicator(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ): hasResult ?
              _details() : _failure()
            ],
          ),
        ),
      ),
    );
  }

  Widget _details() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            statCard(
                context, "Avg Checked In", averageCit, Icons.south_west_sharp),
            statCard(
                context, "Avg Checked Out", averageCot, Icons.north_east_sharp),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 140,
          child: CircleProgressBar(
            strokeWidth: 8,
            foregroundColor: double.parse(percentage) > 0.60
                ? Colors.green
                : Colors.redAccent,
            backgroundColor: Colors.white,
            value: double.parse(percentage),
            child: attendancePercentage(),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            sendEmail();
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(8))),
          child: const SizedBox(
            width: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email_sharp,
                  color: Colors.black,
                  size: 24,
                ),
                SizedBox(width: 16),
                Text(
                  "Email Student",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _failure() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.cancel,
              size: 128,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "No Attendance! \nStudent has no attendance record.",
            style:  TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget attendancePercentage() {
    double percent = double.parse(percentage) * 100;
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$percent%",
            style: const TextStyle(color: Colors.white, fontSize: 36),
            textAlign: TextAlign.center,
          ),
          const Text(
            "Attendance\nDuration",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget statCard(
      BuildContext context, String title, String time, IconData icon) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  width: 48,
                ),
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            ),
          ],
        ));
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

  void _getAttendance() async {
    print(widget.user.studentID);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? classID = prefs.getString('classID');

    try {
      setState(() {
        isLoading = true;
        hasResult = false;
      });

      final attendance = await FirebaseFirestore.instance
          .collection("attendance")
          .where("studentID", isEqualTo: widget.user.studentID)
          .get();

      final fetchClass = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classID)
          .get();

      if (attendance.docs.isNotEmpty) {
        Map<String, dynamic> _classDoc = fetchClass.data()!;
        Timestamp cit = _classDoc['cit'];
        Timestamp cot = _classDoc['cot'];

        List<DateTime> classCitList = [];
        List<DateTime> classCotList = [];

        classCitList.add(cit.toDate());
        classCotList.add(cot.toDate());

        double classCitValue = convertAverageDateTimeToNumber(classCitList);
        double classCotValue = convertAverageDateTimeToNumber(classCotList);

        double classTimeDiff = classCotValue - classCitValue;

        List<DateTime> attendanceCitList = [];
        List<DateTime> attendanceCotList = [];

        for (var docSnapshot in attendance.docs) {
          Map<String, dynamic> _doc = docSnapshot.data();
          Timestamp it = _doc['cit'];
          Timestamp ot = _doc['cot'];

          DateTime cit = it.toDate();
          DateTime cot = ot.toDate();

          attendanceCitList.add(cit);
          attendanceCotList.add(cot);
        }
        String cit_ = DateFormat.jm()
            .format(calculateAverageDateTime(attendanceCitList))
            .toString();
        String cot_ = DateFormat.jm()
            .format(calculateAverageDateTime(attendanceCotList))
            .toString();

        double attendanceCitValue = convertAverageDateTimeToNumber(attendanceCitList);
        double attendanceCotValue = convertAverageDateTimeToNumber(attendanceCotList);

        double attendanceTimeDiff = attendanceCotValue - attendanceCitValue;

        print("attendanceTimeDiff $attendanceTimeDiff");

        double percentile = (attendanceTimeDiff / classTimeDiff);
        var percentage = NumberFormat('##.0##', 'en_US');

        print(attendanceTimeDiff);
        print(classTimeDiff);

        print(percentile);
        print(percentage.format(percentile));


        setState(() {
          this.percentage = percentage.format(percentile);
          isLoading = false;
          hasResult = true;
          averageCit = cit_;
          averageCot = cot_;
        });
      } else{
        setState(() {
          isLoading = false;
          hasResult = false;
        });
      }

    } catch (e) {
      setState(() {
        isLoading = false;
        hasResult = false;
      });
    }
  }
}
