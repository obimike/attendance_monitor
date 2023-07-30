import 'dart:io';

import 'package:Attendance_Monitor/admin/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/dashboard_event.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/bloc/dashboard_state.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/addClass.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/changePassword.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/class_detail.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/dashboard_body.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/student_list.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/repository/dashboard_repository.dart';
import 'package:Attendance_Monitor/common/welcome/welcome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  void _updateProfileImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final Reference ref = FirebaseStorage.instance.ref();
    final db = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

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
                  builder: (BuildContext context) => const Welcome(),
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
                      ?  const DashBoardBody()
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
                            Navigator.of(context).push(
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

}
