import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Attendify",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                ),
              ),
            ]),
            const SizedBox(height: 48),
            const Text(
              "Admin Login",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              "Email ID",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
            TextField(
              controller: _emailController,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => const Login()),
                // );
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            // Stack(children: [
            //   Positioned(child:
            //   Row(children: [
            //
            //   ],))
            // ],)
          ],
        ),
      ),
    ));
  }
}
