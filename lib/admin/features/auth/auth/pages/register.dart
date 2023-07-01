import 'package:Attendance_Monitor/admin/features/auth/auth/pages/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    var dynamicHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Attendify",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ]),
                  const SizedBox(height: 48),
                   Text(
                    "Admin Registration",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 48),
                   Text(
                    "Full Name (Last Name first)",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  TextField(
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Email ID",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  TextField(
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Authorization Key",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  TextField(
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Designation",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  TextField(
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                   Text(
                    "Password",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                   Text(
                    "Confirm Password",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
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
                  Text(
                    "By registering, you’ve agree to our Terms & Conditions and Privacy Policy.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (context) => const Login()),
                      // );
                    },
                    child: SizedBox(
                      width: dynamicWidth,
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "Have and account?",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const Login()),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: Colors.deepOrange[300],
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16,),
                ],
              ),
            ),
          ),
        ));
  }
}
