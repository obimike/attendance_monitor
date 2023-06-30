import 'package:Attendance_Monitor/admin/features/auth/auth/pages/login.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  // Image.asset("", width: 12,),
                  Center(
                    child: Image.asset(
                      "images/welcome.png",
                      width: 320,
                      height: 360,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Attendance monitoring at your  finger’s tip,  bid farewell to the hassle of manual attendance sheets and embrace the efficiency of digital record-keeping.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "I’m a Student",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const Login()),
                          );
                        },
                        child: const Text(
                          "I’m an Administrator",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
