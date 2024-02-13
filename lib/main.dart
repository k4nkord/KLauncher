import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'src/homepage.dart';
import 'src/menupage.dart';
import 'src/data.dart';

void main() => runApp(
    ChangeNotifierProvider(create: (context) => Data(), child: const KApp()));

class KApp extends StatefulWidget {
  const KApp({super.key});

  @override
  State<KApp> createState() => _KAppState();
}

class _KAppState extends State<KApp> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    return MaterialApp(
        home: PageView(
            controller: context.watch<Data>().controller,
            children: const [
              HomePage(),
              MenuPage(),
            ]),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: data.seedColor,
              background: data.darkTheme ? Colors.black : Colors.white,
              secondary: data.secondaryColor),
          textTheme: TextTheme(
              bodyMedium:
                  GoogleFonts.exo2(fontSize: 18, fontWeight: FontWeight.w500),
              bodySmall: GoogleFonts.exo2(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: context.watch<Data>().secondaryColor)),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            backgroundColor: data.secondaryColor,
            foregroundColor: data.seedColor,
          )),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: data.seedColor,
            foregroundColor: data.secondaryColor,
          ),
        ));
  }
}
