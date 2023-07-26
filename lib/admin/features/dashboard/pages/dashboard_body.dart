import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashBoardBody extends StatefulWidget {
  const DashBoardBody({super.key});

  @override
  State<DashBoardBody> createState() => _DashBoardBodyState();
}

class _DashBoardBodyState extends State<DashBoardBody> {
  late DateTime _selectedDate;
  late String _formattedDate;

  late TimeOfDay _selectedTime;

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedTime,
  //   );
  //
  //   if (pickedTime != null && pickedTime != _selectedTime) {
  //     setState(() {
  //       _selectedTime = pickedTime;
  //     });
  //   }
  // }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
    _formattedDate = DateFormat.yMMMEd().format(DateTime.now());
    _selectedTime = TimeOfDay.now();
  }

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _onDateSelect(date) {
    setState(() => _selectedDate = date);
    setState(
        () => _formattedDate = DateFormat.yMMMEd().format(date).toString());
  }

  @override
  Widget build(BuildContext context) {
    var dynamicHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "NUC Students (Overview)",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              statCard(
                  context, "Total Students", "2801", Icons.groups_outlined),
              statCard(context, "Total Attendance", "890/1990",
                  Icons.south_west_sharp),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              statCard(
                  context, "Avg Checked In", "8:39am", Icons.south_west_sharp),
              statCard(
                  context, "Avg Checked Out", "5:01pm", Icons.north_east_sharp),
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
          Center(
            child: SizedBox(
              width: 180,
              child: CircleProgressBar(
                strokeWidth: 8,
                foregroundColor: Colors.redAccent,
                backgroundColor: Colors.white,
                value: 0.65,
                child: attendancePercentage(),
              ),
            ),
          ),
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "65%",
            style: TextStyle(color: Colors.white, fontSize: 48),
          ),
          Text(
            "Attendance",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
