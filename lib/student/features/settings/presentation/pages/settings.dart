import 'package:Attendance_Monitor/student/features/settings/presentation/pages/change_password.dart';
import 'package:Attendance_Monitor/student/features/settings/presentation/pages/feedback.dart';
import 'package:Attendance_Monitor/student/features/settings/presentation/pages/privacy.dart';
import 'package:Attendance_Monitor/student/features/settings/presentation/pages/profile.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16.0),
              width: dynamicWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settings",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Update your preferences",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Settings",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  settingsCard(
                      context,
                      "Profile Information",
                      "Name, Email,  School ID, DOB...",
                      Icons.person_sharp,
                      const Profile()),
                  const SizedBox(
                    height: 8,
                  ),
                  settingsCard(
                      context,
                      "Change Password",
                      "Current password, New password",
                      Icons.key,
                      const ChangePassword()),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "General",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  settingsCard(context, "Send Feedback", "Share your thought",
                      Icons.message_outlined, const FeedbackMessage()),
                  const SizedBox(
                    height: 8,
                  ),
                  settingsCard(context, "Privacy Policy", "Term of use",
                      Icons.sticky_note_2_outlined, const Privacy()),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      child: const Text(
                        "Log Out",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget settingsCard(BuildContext context, String title, String subtitle,
      IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: Icon(icon),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.white,
                size: 24,
              ),
            ],
          )),
    );
  }
}
