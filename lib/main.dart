import 'package:Attendance_Monitor/common/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color.fromARGB(255, 51, 51, 51),
        inputDecorationTheme: const InputDecorationTheme(
            fillColor:  Colors.white,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
            outlineBorder: BorderSide(color: Colors.white),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            filled: true)

      ),
      home: const Splash(),
    );
  }
}
