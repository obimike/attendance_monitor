import 'package:Attendance_Monitor/admin/features/dashboard/pages/addClass.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/class_detail.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/student_list.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
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

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String get _confirmPassword => _confirmPasswordController.text;
  String get _newPassword => _newPasswordController.text;
  String get _currentPassword => _currentPasswordController.text;

  bool _obscureText = true;

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

  void showChangePasswordDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              // width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Change Password",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Text(
                      "Current Password",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextField(
                      controller: _currentPasswordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "New Password",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Confirm Password",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(builder: (context) => const DashBoard()),
                        // );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Submit Changes",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    var dynamicHeight = MediaQuery.of(context).size.height;
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
        child: Padding(
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
                  statCard(context, "Avg Checked In", "8:39am",
                      Icons.south_west_sharp),
                  statCard(context, "Avg Checked Out", "5:01pm",
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
        ),
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
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('images/user.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Peter Parker",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Head of Department",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "peter_parker@yahoo.com",
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
                showChangePasswordDialog(context);
              },
            ),
            const ListTile(
              title: Text(
                "Tasks",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_sharp),
              title: const Text(
                "Student's List",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const StudentList()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_sharp),
              title: const Text(
                'Add  Class',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              onTap: () {
                // Handle Home navigation
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddClass()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_sharp),
              title: const Text(
                'Class Detail',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              onTap: () {
                // Handle Home navigation
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ClassDetail()),
                );
              },
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
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
