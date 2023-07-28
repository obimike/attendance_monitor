import 'dart:io';

import 'package:Attendance_Monitor/student/features/settings/data/models/settings_repository.dart';
import 'package:Attendance_Monitor/student/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:Attendance_Monitor/student/features/settings/presentation/bloc/settings_event.dart';
import 'package:Attendance_Monitor/student/features/settings/presentation/bloc/settings_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => SettingsBloc(
        RepositoryProvider.of<SettingsRepository>(context),
      )..add(InitEvent()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.status == SettingsStatus.loading) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Profile",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _loading(deviceHeight),
              ),
            );
          }
          if (state.status == SettingsStatus.success) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Profile",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 180,
                                  width: 180,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 90,
                                        foregroundImage:
                                            NetworkImage(state.imageUrl ?? ""),
                                        backgroundImage:
                                            const AssetImage('images/user.png'),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.black,
                                            child: IconButton(
                                                onPressed: () {
                                                  _updateProfileImage(context);
                                                },
                                                color: Colors.white,
                                                iconSize: 36,
                                                icon: Icon(Icons
                                                    .photo_camera_outlined)),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 48,
                              ),
                              Container(
                                width: dynamicWidth,
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Full Name",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Text(
                                      state.name.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      "Gender",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Text(
                                      state.gender.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      "Department:",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Text(
                                      state.department.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      "Class ID:",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Text(
                                      state.classID.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      "Email ID",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Text(
                                      state.email.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Text(
                                      "Date Of Birth",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    Text(
                                      state.dob.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Class detail",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.start,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _failure(deviceHeight),
            ),
          );
        },
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

  Widget _failure(double deviceHeight) {
    return SizedBox(
      height: deviceHeight * 0.8,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                Icons.error,
                size: 256,
                color: Colors.redAccent,
              ),
            ),
            Text(
              "An Error has occurred \nCheck your connection and try again.",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

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
          .child('users')
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
          .collection("users")
          .doc(_user.uid)
          .update({"imageUrl": link}).catchError((e) {
        throw Exception(e.toString());
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
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
            builder: (BuildContext context) => const Profile(),
          ),
        );
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'Error: ${e.message}',
            style: const TextStyle(color: Colors.redAccent, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
