import 'package:Attendance_Monitor/student/features/auth/data/repositories/student_auth.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/bloc/signup_event.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/bloc/signup_state.dart';
import 'package:Attendance_Monitor/student/features/auth/presentation/pages/signin.dart';
import 'package:Attendance_Monitor/student/features/history/presentation/pages/history.dart';
import 'package:Attendance_Monitor/student/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  String genderValue = "Male";

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set initialDate to the current date
      firstDate: DateTime(1920),
      lastDate: DateTime(2025), // Set lastDate to a future date
    );

    if (picked != null && picked != _selectedDate) {
      context.read<SignUpBloc>().add(SignupDOBChangedEvent(
          dob: DateFormat.yMMMMd().format(picked).toString()));

      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    var dynamicHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: BlocProvider(
      create: (context) => SignUpBloc(
        RepositoryProvider.of<StudentAuthRepository>(context),
      ),
      child: BlocBuilder<SignUpBloc, SignupState>(
        builder: (context, state) {
          if (state.status == SignupStatus.success) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const Home(),
                ),
              );
            });
            print("SignupStatus.success");
          }
          return Scaffold(
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
                      "Student SignUp",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
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
                      "Full Name (Last Name first)",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context
                            .read<SignUpBloc>()
                            .add(SignupNameChangedEvent(name: value));
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Class ID (Get from Administrator)",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context
                            .read<SignUpBloc>()
                            .add(SignupClassIDChangedEvent(classID: value));
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Department",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context.read<SignUpBloc>().add(
                            SignupDepartmentChangedEvent(department: value));
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
                            .read<SignUpBloc>()
                            .add(SignupEmailChangedEvent(email: value));
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Gender",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    Row(
                      children: ["Male", "Female"]
                          .map(
                            (e) => SizedBox(
                              width: 180,
                              child: ListTile(
                                title: Text(
                                  e,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.start,
                                ),
                                leading: Radio<String>(
                                  value: e,
                                  groupValue: genderValue,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      setState(() {
                                        genderValue = value;
                                      });
                                      context.read<SignUpBloc>().add(
                                          SignupGenderChangedEvent(
                                              gender: value));
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Date of Birth",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_sharp,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Password",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context
                            .read<SignUpBloc>()
                            .add(SignupPasswordChangedEvent(password: value));
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
                    const SizedBox(height: 12),
                    Text(
                      "Confirm Password",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      onChanged: ((value) {
                        context.read<SignUpBloc>().add(
                            SignupConfirmPasswordChangedEvent(
                                confirmPassword: value));
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
                    const SizedBox(height: 24),
                    Text(
                      "By registering, you’ve agree to our Terms & Conditions and Privacy Policy.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => (state.status == SignupStatus.loading)
                          ? null
                          : context
                              .read<SignUpBloc>()
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
                                "Sign Up",
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
                                  builder: (context) => const SignIn()),
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
          );
        },
      ),
    ));
  }
}
