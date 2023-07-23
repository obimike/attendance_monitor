import 'package:Attendance_Monitor/student/features/auth/data/repositories/student_auth.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/bloc/login/login_event.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/bloc/login/login_state.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/pages/signup.dart';
import 'package:Attendance_Monitor/student/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
        child: BlocProvider(
      create: (context) => LoginBloc(
        RepositoryProvider.of<StudentAuthRepository>(context),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.status == LoginStatus.success) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const Home(),
                ),
              );
            });
          }

          return Scaffold(
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
                      "Student Sign In",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 36),
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
                    const SizedBox(height: 12),
                    Text(
                      "Email ID",
                      style: Theme.of(context).textTheme.bodyMedium,
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
                    Text(
                      "Password",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context
                            .read<LoginBloc>()
                            .add(LoginPasswordChangedEvent(password: value));
                      }),
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
                          "Sign In",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Are you new here?",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()),
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
          );
        },
      ),
    ));
  }
}
