import 'package:Attendance_Monitor/location_service.dart';
import 'package:Attendance_Monitor/student/features/history/data/repositories/history_repository.dart';
import 'package:Attendance_Monitor/student/features/history/presentation/bloc/history_bloc.dart';
import 'package:Attendance_Monitor/student/features/history/presentation/bloc/history_event.dart';
import 'package:Attendance_Monitor/student/features/history/presentation/bloc/history_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryLog extends StatefulWidget {
  const HistoryLog({super.key});

  @override
  State<HistoryLog> createState() => _HistoryLogState();
}

class _HistoryLogState extends State<HistoryLog> {
  late DateTime _selectedDate;
  late String _formattedDate;

  final auth = FirebaseAuth.instance.currentUser;

  void _onDateSelect(date, BuildContext context) {
    setState(() => _selectedDate = date);
    setState(() {
      _formattedDate = DateFormat.yMMMMEEEEd().format(date).toString();
      context.read<HistoryBloc>().add(SelectDateEvent(date: date));
      print(date);
    });
  }

  @override
  void initState() {
    getPermission();
    super.initState();
    _selectedDate = DateTime.now();
    _formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
  }

  getPermission() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPermitted = await LocationService().getPermission();
    prefs.setBool('isPermitted', isPermitted);
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => HistoryBloc(
        RepositoryProvider.of<HistoryRepository>(context),
      )..add(InitEvent()),
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              foregroundImage: NetworkImage(
                                  auth!.photoURL == null
                                      ? ""
                                      : auth!.photoURL!),
                              backgroundImage:
                                  const AssetImage('images/user.png'),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  auth!.displayName!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  auth!.email!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            )
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
                            CalendarTimeline(
                              // showYears: true,
                              initialDate: _selectedDate,
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 4)),
                              onDateSelected: (date) =>
                                  _onDateSelect(date, context),
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
                            if (state.status == HistoryStatus.loading)
                              _loading(),
                            if (state.status == HistoryStatus.failure)
                              _failure(state),
                            if (state.status == HistoryStatus.success)
                              stat(state),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget stat(HistoryState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            statCard(context, "Checked In", state.cit, Icons.south_west_sharp),
            statCard(context, "Checked Out", state.cot, Icons.north_east_sharp),
          ],
        ),
        const SizedBox(
          height: 48,
        ),
        SizedBox(
          width: 180,
          child: CircleProgressBar(
            strokeWidth: 16,
            foregroundColor: double.parse(state.percentage) > 0.65
                ? Colors.green
                : Colors.redAccent,
            backgroundColor: Colors.white,
            value: double.parse(state.percentage),
            child: attendancePercentage(state),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          double.parse(state.percentage) > 0.60
              ? double.parse(state.percentage) > 0.80
              ? "Excellent attendance duration": "Good attendance duration"
              : "Poor attendance duration",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget attendancePercentage(HistoryState state) {
    double percent = double.parse(state.percentage) * 100;
    String p = percent.toString();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$p%",
            style: const TextStyle(color: Colors.white, fontSize: 36),
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

  Widget _loading() {
    return const SizedBox(
      height: 320,
      child: Center(
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

  Widget _failure(HistoryState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 24,
          ),
          const Center(
            child: Icon(
              Icons.cancel,
              size: 128,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            state.message,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
