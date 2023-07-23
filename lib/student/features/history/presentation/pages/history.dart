import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:intl/intl.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';

class HistoryLog extends StatefulWidget {
  const HistoryLog({super.key});

  @override
  State<HistoryLog> createState() => _HistoryLogState();
}

class _HistoryLogState extends State<HistoryLog> {
  late DateTime _selectedDate;
  late String _formattedDate;


  void _onDateSelect(date) {
    setState(() => _selectedDate = date);
    setState(
            () => _formattedDate = DateFormat.yMMMMEEEEd().format(date).toString());
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('images/user.png'),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      "Natashia Khaleria",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),Text(
                      "natashia_khaleria@gmail.com",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    child: Text(
              _formattedDate.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  // CalendarTimeline(
                  //   // showYears: true,
                  //   initialDate: _selectedDate,
                  //   firstDate: DateTime(2023),
                  //   lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
                  //   onDateSelected: (date) => _onDateSelect(date),
                  //   leftMargin: 20,
                  //   monthColor: Colors.white70,
                  //   dayColor: Colors.teal[200],
                  //   dayNameColor: const Color(0xFF333A47),
                  //   activeDayColor: Colors.white,
                  //   activeBackgroundDayColor: Colors.redAccent[100],
                  //   dotsColor: const Color(0xFF333A47),
                  //   selectableDayPredicate: (date) => date.day != 23,
                  //   locale: 'en',
                  // ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Attendance",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      statCard(context, "Checked In", "8:45am",
                          Icons.south_west_sharp),
                      statCard(context, "Checked Out", "2:30pm",
                          Icons.north_east_sharp),
                    ],
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  SizedBox(
                    width: 180,
                    child: CircleProgressBar(
                      strokeWidth: 16,
                      foregroundColor: Colors.redAccent,
                      backgroundColor: Colors.white,
                      value: 0.73,
                      child: attendancePercentage(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "On Time",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            )

          ]),
        ),
      ),
    );
  }



  Widget attendancePercentage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "65%",
            style: TextStyle(color: Colors.white, fontSize: 36),
          ),
          Text(
            "Attendance",
            style: TextStyle(color: Colors.white, fontSize: 14),
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
}
