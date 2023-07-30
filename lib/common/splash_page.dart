import 'dart:async';

import 'package:Attendance_Monitor/common/onboarding/onboarding.dart';
import 'package:Attendance_Monitor/common/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<SharedPreferences> pref = SharedPreferences.getInstance();
    late bool firstLaunch = false;

    Future<void> isFirstTimer() async {
      final SharedPreferences prefs = await pref;
      final bool? firstTime = prefs.getBool('firstTime');

      if (firstTime == false) {
        await prefs.setBool('firstTime', true);
        firstLaunch = false;
      } else {
        firstLaunch = true;
      }
    }

    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                isFirstTimer();

                if (firstLaunch) {
                  return const OnBoarding();
                } else {
                  return const Welcome();
                }
              }),
            ));

    var dynamicHeight = MediaQuery.of(context).size.height;
    var dynamicWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            bottom: dynamicHeight * 0.45,
            left: dynamicWidth * 0.33,
            child: Column(
              children: [
                // Image.asset("", width: 12,),
                Center(
                  child: Image.asset(
                    "images/logo.png",
                    width: 120,
                  ),
                ),
                // const SizedBox(height: 8),
                const Text(
                  "Attendify",
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const  Positioned(
            bottom: 36,
            left:  50,
            right: 50,
            child:  Text(
              "Attendance Monitoring App.",
              style: TextStyle(
                fontSize:20,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
