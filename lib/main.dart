import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/khomescreen.dart';

void main() => runApp(const KApp());

class KApp extends StatefulWidget {
  const KApp({super.key});

  @override
  State<KApp> createState() => _KAppState();
}

class _KAppState extends State<KApp> {
  bool darkTheme = true;
  Color seedColor = Colors.white;
  Color secondaryColor = const Color(0xff222222);
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const KHomeScreen(),
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor,
              background: darkTheme ? Colors.black : Colors.white, 
              secondary: secondaryColor),
            textTheme: TextTheme(
                bodyMedium: GoogleFonts.exo2(
                    fontSize: 18, fontWeight: FontWeight.w500),
                bodySmall: GoogleFonts.exo2(
                  fontSize: 18, fontWeight: FontWeight.w500, color: secondaryColor
                )),
            ));
  }

  @override
  initState() {
    super.initState();
    if (!initialized) {
      _init();
    }
  }

  void _init() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setBool('darkTheme', false);
    prefs.setInt('seedColor', 0xff0000ff);
    prefs.setInt('secondaryColor', 0xffff0000);

    darkTheme = prefs.getBool('darkTheme') ?? darkTheme;
    seedColor = Color(prefs.getInt('seedColor') ?? seedColor.value);
    secondaryColor = Color(prefs.getInt('secondaryColor') ?? secondaryColor.value);
    setState(() {
      initialized = true;
    });
  }
}
