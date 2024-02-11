import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'src/homepage.dart';
import 'src/menupage.dart';
import 'src/data.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => Data(),
    child: const KApp()));

class KApp extends StatefulWidget {
  const KApp({super.key});

  @override
  State<KApp> createState() => _KAppState();
}

class _KAppState extends State<KApp> {
  @override
  Widget build(BuildContext context) {
    return 
      MaterialApp(
        home: PageView(children: const [
          HomePage(),
          MenuPage()
        ]),
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: context.watch<Data>().seedColor,
              background: context.watch<Data>().darkTheme ? Colors.black : Colors.white, 
              secondary: context.watch<Data>().secondaryColor),
            textTheme: TextTheme(
                bodyMedium: GoogleFonts.exo2(
                    fontSize: 18, fontWeight: FontWeight.w500),
                bodySmall: GoogleFonts.exo2(
                  fontSize: 18, fontWeight: FontWeight.w500, color: context.watch<Data>().secondaryColor
                )),
            ));
  }
}
