import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardBody extends StatefulWidget {
  const DashBoardBody({super.key});

  @override
  State<DashBoardBody> createState() => _DashBoardBodyState();
}

class _DashBoardBodyState extends State<DashBoardBody> {
  late DateTime _selectedDate;
  late String _formattedDate;
  bool isLoading = true;
  bool isSelectDateLoading = false;
  bool hasResult = false;
  int allStudentsCount = 0;
  String className = '';
  String averageCit = '';
  String averageCot = '';
  String percentage = "0.0";

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
    _formattedDate = DateFormat.yMMMEd().format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
    _getClassDetails();
  }

  void _onDateSelect(date) {
    setState(() {
      _selectedDate = date;
      _formattedDate = DateFormat.yMMMEd().format(date).toString();
    });

    selectDateEvent(date);
    setState(() {

    });
  }

  _getClassDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String classID = prefs.getString("classID") ?? "";
    print("_getClassDetails classID $classID");

    try {
      final db = await FirebaseFirestore.instance;
      final students = await FirebaseFirestore.instance
          .collection("users")
          .where("classID", isEqualTo: classID)
          .get();

      print("_getClassDetails classID ${students.size}");

      final fetchClass = await db.collection("classes").doc(classID).get();

      final attendance = await db
          .collection("attendance")
          .where("classID", isEqualTo: classID)
          .get();

      if (fetchClass.data()!.isNotEmpty) {
        Map<String, dynamic> classDoc_ = fetchClass.data()!;
        String name = classDoc_['name'];
        Timestamp classCit_ = classDoc_['cit'];
        Timestamp classCot_ = classDoc_['cot'];

        setState(() {
          className = name;
          allStudentsCount = students.size;
        });

        DateTime today = DateTime.now();
        var todayDate = DateFormat.yMd().format(today);
        List<DateTime> classCitList = [];
        List<DateTime> classCotList = [];

        classCitList.add(classCit_.toDate());
        classCotList.add(classCot_.toDate());

        double citValue = convertAverageDateTimeToNumber(classCitList);
        double cotValue = convertAverageDateTimeToNumber(classCotList);

        double classTimeDiff = cotValue - citValue;

        print("classTimeDiff $classTimeDiff");

        if (attendance.docs.isNotEmpty) {
          List<DateTime> citList = [];
          List<DateTime> cotList = [];
          List<DateTime> citList_ = [];
          List<DateTime> cotList_ = [];
          for (var docSnapshot in attendance.docs) {
            Timestamp it = docSnapshot['cit'];
            Timestamp ot = docSnapshot['cot'];
            Timestamp attendanceDate = docSnapshot['date'];

            DateTime cit = it.toDate();
            DateTime cot = ot.toDate();

            citList.add(cit);
            cotList.add(cot);

            var setDate = DateFormat.yMd().format(attendanceDate.toDate());
            
            print("setDate $setDate");
            print("todayDate $todayDate");

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

          setState(() {
            averageCit = cit_;
            averageCot = cot_;
          });

          double citValue_ = convertAverageDateTimeToNumber(citList_);
          double cotValue_ = convertAverageDateTimeToNumber(cotList_);

          double attendanceTimeDiff = cotValue_ - citValue_;

          print("attendanceTimeDiff $attendanceTimeDiff");

          double percentile = (attendanceTimeDiff / classTimeDiff);
          var percentage = NumberFormat('##.0##', 'en_US');

          print(percentile);


          setState(() {
            this.percentage = percentage.format(percentile);
          });
        }
      }

      setState(() {
        hasResult = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasResult = false;
        isLoading = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dynamicHeight = MediaQuery.of(context).size.height;
    return isLoading
        ? _loading(dynamicHeight)
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "$className (Overview)",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.groups_outlined,
                            color: Colors.white,
                            size: 36,
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Text(
                            "Total Students in your class",
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Text(
                        "$allStudentsCount",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    statCard(
                        context,
                        "Avg Checked In",
                        averageCit.isNotEmpty ? averageCit : "Nil",
                        Icons.south_west_sharp),
                    statCard(
                        context,
                        "Avg Checked Out",
                        averageCot.isNotEmpty ? averageCot : "Nil",
                        Icons.north_east_sharp),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today’s Attendance",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      _formattedDate.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                CalendarTimeline(
                  // showYears: true,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
                  onDateSelected: (date) => _onDateSelect(date),
                  leftMargin: 20,
                  monthColor: Colors.white70,
                  dayColor: Colors.teal[200],
                  dayNameColor: const Color(0xFF333A47),
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.redAccent[100],
                  dotsColor: const Color(0xFF333A47),
                  selectableDayPredicate: (date) => date.day != 23,
                  locale: 'en',
                ),
                const SizedBox(
                  height: 24,
                ),
                const SizedBox(height: 16),
                isSelectDateLoading
                    ? const SizedBox(
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
                      )
                    :  hasResult ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 180,
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
                           const SizedBox(height: 16,),
                            Text(
                              double.parse(percentage) > 0.60
                                  ? double.parse(percentage) > 0.80
                                  ? "Excellent Student's attendance duration"
                                  : "Good Student's  attendance duration"
                                  : "Poor Student's  attendance duration",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ):  _failure(),
              ],
            ),
          );
  }

  Widget statCard(
      BuildContext context, String title, String score, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 180,
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 36,
              ),
              const SizedBox(
                width: 24,
              ),
              Text(
                score,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
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
      ),
    );
  }

  Widget attendancePercentage() {
    double percent = double.parse(percentage) * 100;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$percent%",
            style: const TextStyle(color: Colors.white, fontSize: 48),
          ),
          const Text(
            "Attendance \nDuration",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _loading(double deviceHeight) {
    return SizedBox(
      height: deviceHeight * 0.8,
      child: const Center(
        child: SizedBox(
          height: 64,
          width: 64,
          child: CircularProgressIndicator(
            color: Colors.redAccent,
          ),
        ),
      ),
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
            "No Attendance! \nThere is no record of attendance on this date.",
            style:  TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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

  Future<void> selectDateEvent(DateTime event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String classID = prefs.getString("classID") ?? "";
    print(classID);

    setState(() {
      isSelectDateLoading = true;
      hasResult = false;
    });
    try {
      final db = await FirebaseFirestore.instance;

      final fetchClass = await db.collection("classes").doc(classID).get();

      final attendance = await db
          .collection("attendance")
          .where("classID", isEqualTo: classID)
          .get();

      if (fetchClass.data()!.isNotEmpty) {
        Map<String, dynamic> classDoc_ = fetchClass.data()!;
        Timestamp classCit_ = classDoc_['cit'];
        Timestamp classCot_ = classDoc_['cot'];

        var todayDate = DateFormat.yMd().format(event);

        List<DateTime> classCitList = [];
        List<DateTime> classCotList = [];

        classCitList.add(classCit_.toDate());
        classCotList.add(classCot_.toDate());

        double citValue = convertAverageDateTimeToNumber(classCitList);
        double cotValue = convertAverageDateTimeToNumber(classCotList);

        double classTimeDiff = cotValue - citValue;

        print("classTimeDiff $classTimeDiff");
        print("outside attendance is empty if statement");
        if (attendance.docs.isNotEmpty) {
          List<DateTime> citList = [];
          List<DateTime> cotList = [];
          List<DateTime> citList_ = [];
          List<DateTime> cotList_ = [];
          for (var docSnapshot in attendance.docs) {
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
            } else {
              setState(() {
                isSelectDateLoading = false;
                hasResult = false;
              });
            }
          }

          double citValue_ = convertAverageDateTimeToNumber(citList_);
          double cotValue_ = convertAverageDateTimeToNumber(cotList_);

          double attendanceTimeDiff = cotValue_ - citValue_;

          print("attendanceTimeDiff $attendanceTimeDiff");

          double percentile = (attendanceTimeDiff / classTimeDiff);
          var percentage = NumberFormat('##.0##', 'en_US');

          print(percentile);

          setState(() {
            this.percentage = percentage.format(percentile);
            hasResult = true;
          });
        } else{
          print("attendance is empty");
          setState(() {
            isSelectDateLoading = false;
            hasResult = false;
          });
          throw ("Error");
        }
      }

      setState(() {
        isSelectDateLoading = false;
        hasResult = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasResult = false;
      });

      print(e);
    }
  }
}
