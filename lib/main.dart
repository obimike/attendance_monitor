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
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white, size: 36)),
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            titleLarge: TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
            ),
            bodyLarge: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
            ),
            bodyMedium: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
            ),
            bodySmall: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 51, 51, 51),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.transparent,
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          outlineBorder: BorderSide(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            textStyle: MaterialStateProperty.all(
               const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),

            )
          ),
          
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),

      ),
      home: const Splash(),
    );
  }
}
