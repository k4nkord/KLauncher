import 'package:flutter/material.dart';
import 'src/khomescreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  runApp(const KApp());
}

class KApp extends StatelessWidget {
  const KApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const KHomeScreen(),
        theme: ThemeData(
            colorScheme: const ColorScheme.dark(background: Colors.black),
            disabledColor: const Color(0xff333333),
            textTheme: TextTheme(
                bodyMedium: GoogleFonts.exo2(
                    fontSize: 18, fontWeight: FontWeight.w500)),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white)),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xff111111),
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff111111),
              foregroundColor: Colors.white,
            ))));
  }
}
