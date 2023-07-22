import 'package:Attendance_Monitor/admin/features/auth_service/auth.dart';
import 'package:Attendance_Monitor/admin/features/login/bloc/login_bloc.dart';
import 'package:Attendance_Monitor/admin/features/login/bloc/login_event.dart';
import 'package:Attendance_Monitor/admin/features/login/bloc/login_state.dart';
import 'package:Attendance_Monitor/admin/features/signup/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dashboard/pages/dashboard.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    var dynamicHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => LoginBloc(
        RepositoryProvider.of<AuthService>(context),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.status == LoginStatus.success) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoard(),
                ),
              );
            });
          }
          return SafeArea(
              child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    if (state.status == LoginStatus.failure)
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
                    const Text(
                      "Email ID",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context
                            .read<LoginBloc>()
                            .add(LoginEmailChangedEvent(email: value));
                      }),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context
                            .read<LoginBloc>()
                            .add(LoginPasswordChangedEvent(password: value));
                      }),
                      obscureText: true,
                      // decoration: InputDecoration(
                      //   suffixIcon: IconButton(
                      //       icon: Icon(
                      //         (state is PasswordVisible)
                      //             ? Icons.visibility_off
                      //             : Icons.visibility,
                      //       ),
                      //       onPressed: () =>
                      //       {print(state),
                      //       context
                      //           .read<AuthBloc>()
                      //           .add(TogglePasswordVisibilityEvent())
                      //     },),
                      // ),
                    ),
                    const SizedBox(height: 36),
                    ElevatedButton.icon(
                      onPressed: () => (state.status == LoginStatus.loading)
                          ? null
                          : context
                              .read<LoginBloc>()
                              .add(LoginButtonPressedEvent()),
                      icon: (state.status == LoginStatus.loading)
                          ? const CircularProgressIndicator(
                              strokeWidth: 3,
                            )
                          : const Icon(Icons.feedback,
                              color: Colors.transparent),
                      label: SizedBox(
                        width: dynamicWidth,
                        child: (state.status == LoginStatus.loading)
                            ? const Text(
                                "Authenticating, Please wait...",
                                textAlign: TextAlign.center,
                              )
                            : const Text(
                                "Login",
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Are you new here?",
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const Register()),
                            );
                          },
                          child: Text(
                            "Register",
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
                    )
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
