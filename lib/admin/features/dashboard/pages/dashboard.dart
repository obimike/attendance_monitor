import 'package:Attendance_Monitor/admin/features/dashboard/pages/addClass.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late DateTime _selectedDate;
  late String _formattedDate;

  late TimeOfDay _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

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
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }


  final List<String> _options = ['Everyday', 'Sunday', 'Monday', 'Tuesday'];


  bool _isChecked = false;

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
                  statCard(context),
                  statCard(context),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statCard(context),
                  statCard(context),
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
                firstDate: DateTime.now(),
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
              // const Center(
              //   child: CircleAvatar(
              //     radius: 96,
              //     backgroundColor: Colors.white,
              //     child: Center(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             "65%",
              //             style: TextStyle(color: Colors.black, fontSize: 48),
              //           ),
              //           Text(
              //             "Attendance",
              //             style: TextStyle(color: Colors.black, fontSize: 16),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

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
                // Handle Home navigation
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

  Widget statCard(context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          const Icon(
            Icons.group_sharp,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1900",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Total Students",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget studentCard(context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('images/user.png'),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Peter Ajose",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              Text(
                "peter_ajose@gmail.com",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.start,
              ),
            ],
          )
        ],
      ),
    );
  }
}
