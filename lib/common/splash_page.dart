import 'package:Attendance_Monitor/common/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 3)).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnBoarding()),
      );
    });


    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              // Image.asset("", width: 12,),
              Center(
                child: Image.asset(
                  "images/logo.png",
                  width: 96,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Attendify",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const Text(
            "Attendance Monitoring App.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
