import 'package:Attendance_Monitor/student/features/history/presentation/pages/history.dart';
import 'package:Attendance_Monitor/student/features/map/presentation/pages/MapPage.dart';
import 'package:Attendance_Monitor/student/features/settings/presentation/pages/settings.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HistoryLog(),
    const MapPage(),
    const Settings(),
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.grey,
          unselectedIconTheme: const IconThemeData(
            size: 24
          ),

          iconSize: 32,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_input_component_sharp),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
