import 'package:Attendance_Monitor/admin/features/auth_service/auth.dart';
import 'package:Attendance_Monitor/admin/features/login/login.dart';
import 'package:Attendance_Monitor/admin/features/dashboard/pages/dashboard.dart';
import 'package:Attendance_Monitor/admin/features/signup/bloc/signup_bloc.dart';
import 'package:Attendance_Monitor/admin/features/signup/bloc/signup_event.dart';
import 'package:Attendance_Monitor/admin/features/signup/bloc/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => SignupBloc(
        RepositoryProvider.of<AuthService>(context),
      ),
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          if (state.status == SignupStatus.success) {
            // Navigator.of(context).pushReplacement(Home.route());
            print("SignupStatus.success");
          }
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
                    if (state.status == SignupStatus.failure)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            state.message,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              color: Colors.redAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
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
                      onChanged: ((value) {
                        context
                            .read<SignupBloc>()
                            .add(SignupFullNameChangedEvent(fullName: value));
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Email Address",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context
                            .read<SignupBloc>()
                            .add(SignupEmailChangedEvent(email: value));
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Authorization Key",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context
                            .read<SignupBloc>()
                            .add(SignupAuthKeyChangedEvent(authKey: value));
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Designation",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context.read<SignupBloc>().add(
                            SignupDesignationChangedEvent(designation: value));
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Password",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      obscureText: _obscureText,
                      onChanged: ((value) {
                        context
                            .read<SignupBloc>()
                            .add(SignupPasswordChangedEvent(password: value));
                      }),
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
                    const SizedBox(height: 12),
                    Text(
                      "Confirm Password",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      onChanged: ((value) {
                        context.read<SignupBloc>().add(
                            SignupConfirmPasswordChangedEvent(
                                confirmPassword: value));
                      }),
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
                    Text(
                      "By registering, you’ve agree to our Terms & Conditions and Privacy Policy.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      //   Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //         builder: (context) => const DashBoard()),

                      onPressed: () => (state.status == SignupStatus.loading)
                          ? null
                          : context
                              .read<SignupBloc>()
                              .add(const SignupButtonPressedEvent()),
                      icon: (state.status == SignupStatus.loading)
                          ? const CircularProgressIndicator(
                              strokeWidth: 3,
                            )
                          : const Icon(Icons.feedback,
                              color: Colors.transparent),
                      label: SizedBox(
                        width: dynamicWidth,
                        child: (state.status == SignupStatus.loading)
                            ? const Text(
                                "Creating account, please wait...",
                                textAlign: TextAlign.center,
                              )
                            : const Text(
                                "Register",
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
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
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
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
