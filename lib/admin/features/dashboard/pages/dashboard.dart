import 'dart:io';

import 'package:Attendance_Monitor/admin/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/dashboard_event.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/dashboard_state.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/addClass.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/changePassword.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/class_detail.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/student_list.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/repository/dashboard_repository.dart';
import 'package:Attendance_Monitor/admin/features/login/login.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
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

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
    _formattedDate = DateFormat.yMMMEd().format(DateTime.now());
    _selectedTime = TimeOfDay.now();
  }

  void _onDateSelect(date) {
    setState(() => _selectedDate = date);
    setState(
        () => _formattedDate = DateFormat.yMMMEd().format(date).toString());
  }

  void _updateProfileImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final Reference ref = FirebaseStorage.instance.ref();
    final db = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    print("----------------------------------");
    print(image?.name);
    print("----------------------------------");

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': image!.path},
    );

    try {
      final task = await ref
          .child('admins')
          .child('/${image.name}')
          .putFile(File(image.path), metadata);

      final link = (await task.ref.getDownloadURL());

      var _user;
      var admin;

      await auth.authStateChanges().listen((User? user) {
        if (user != null) {
          _user = user;
          user.updatePhotoURL(link);
        }
      });

      await db
          .collection("admins")
          .doc(_user.uid)
          .update({"displayImage": link}).catchError((e) {
        throw Exception(e.toString());
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Profile Image uploaded Successfully!',
            style: TextStyle(color: Colors.green, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) =>
            const DashBoard(),
          ),
        );
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Error: ${e.message}',
            style: const TextStyle(color: Colors.redAccent, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dynamicHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => DashboardBloc(
        RepositoryProvider.of<DashboardRepository>(context),
      )..add(InitEvent()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is LogOutState) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const Login(),
                ),
              );
            });
          }
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Dashboard",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.start,
              ),
            ),
            body: SingleChildScrollView(
              child: (state is InitialState)
                  ? (state.data.hasClass!
                      ? _body(context)
                      : _noClass(dynamicHeight))
                  : _loading(dynamicHeight),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      children: [
                        (state is InitialState)
                            ? CircleAvatar(
                                radius: 60.0,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    const AssetImage('images/user.png'),
                                foregroundImage: NetworkImage(
                                    state.data.displayImage.toString()),
                              )
                            : const CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage('images/user.png'),
                              ),
                        const SizedBox(height: 12),
                        Text(
                          (state is InitialState)
                              ? state.data.fullName.toString()
                              : "Peter Parker",
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          (state is InitialState)
                              ? state.data.designation.toString()
                              : "Head of Department",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          (state is InitialState)
                              ? state.data.email.toString()
                              : "peter_parker@yahoo.com",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      "Account Settings",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt_sharp),
                    title: const Text(
                      'Add Profile Image',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _updateProfileImage(context);
                      // Handle Home navigation
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_sharp),
                    title: const Text(
                      'Change Password',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    onTap: () {
                      // Handle Home navigation
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ChangePassword()),
                      );
                    },
                  ),
                  const ListTile(
                    title: Text(
                      "Tasks",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  if (state is InitialState)
                    Visibility(
                      visible: state.data.hasClass! ? true : false,
                      child: ListTile(
                        leading: const Icon(Icons.person_sharp),
                        title: const Text(
                          "Student's List",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const StudentList()),
                          );
                        },
                      ),
                    ),
                  if (state is InitialState)
                    Visibility(
                      visible: state.data.hasClass! ? false : true,
                      child: ListTile(
                        leading: const Icon(Icons.add_sharp),
                        title: const Text(
                          'Add  Class',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        onTap: () {
                          // Handle Home navigation
                          Navigator.of(context).pop();
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const AddClass(),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  // (state is InitialState)
                  if (state is InitialState)
                    Visibility(
                      visible: state.data.hasClass! ? true : false,
                      child: ListTile(
                        leading: const Icon(Icons.class_sharp),
                        title: const Text(
                          'Class Detail',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        onTap: () {
                          // Handle Home navigation
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const ClassDetail()),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<DashboardBloc>()
                            .add(LogOutButtonPressedEvent());
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
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

  Widget _noClass(double deviceHeight) {
    return SizedBox(
      height: deviceHeight * 0.8,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "images/no_class.png",
                width: 320,
                height: 360,
              ),
            ),
            const Text(
              "You have not class registered yet",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddClass()),
                );
              },
              child: const Text(
                "Add Class",
              ),
            ),
          ],
        ),
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
