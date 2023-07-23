import 'package:Attendance_Monitor/admin/features/dashboard/data/studentList.dart';
import 'package:flutter/material.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';

class Student extends StatelessWidget {
  final StudentListModel user;

 const Student({required this.user, super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Back",
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
                  foregroundImage: NetworkImage(user.imageUrl.toString()),
                  backgroundImage: const AssetImage('images/user.png'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
               user.name,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              Text(
               user.email,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
              Text(
                user.department,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
              Text(
                user.gender,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
              Text(
                  user.dob,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Attendance Stat",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statCard(context, "Avg Checked In", "8:45am",
                      Icons.south_west_sharp),
                  statCard(context, "Avg Checked Out", "2:30pm",
                      Icons.north_east_sharp),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 140,
                child: CircleProgressBar(
                  strokeWidth: 8,
                  foregroundColor: Colors.redAccent,
                  backgroundColor: Colors.white,
                  value: 0.65,
                  child: attendancePercentage(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => const DashBoard()),
                  // );
                },
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(8))),
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
                      SizedBox(width: 8),
                      Text(
                        "Email Student",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
