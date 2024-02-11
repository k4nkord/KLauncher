import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class KWidget extends StatelessWidget {
  final Widget child;
  final bool colored;

  const KWidget(this.child, {this.colored = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: colored
              ? Theme.of(context).disabledColor
              : Theme.of(context).canvasColor,
        ),
        child: child);
  }
}

class KTimeWidget extends StatefulWidget {
  const KTimeWidget({super.key});

  @override
  State<KTimeWidget> createState() => _KTimeWidgetState();
}

class _KTimeWidgetState extends State<KTimeWidget> {
  DateTime time = DateTime.now();
  late Timer timer;
  bool seconds = false;

  _KTimeWidgetState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time = DateTime.now();
      setState(() {});
    });
    _init();
  }

  String parseTime() {
    return '${addZeroes(time.hour)}.${addZeroes(time.minute)}${seconds ? ".${addZeroes(time.second)}" : ""}';
  }

  String addZeroes(int n) => n < 10 ? '0$n' : '$n';

  @override
  Widget build(BuildContext context) {
    return KWidget(Text(
      parseTime(),
      style: GoogleFonts.orbitron(fontSize: 40),
      textAlign: TextAlign.center,
    ));
  }

  void _init() async {
    var prefs = await SharedPreferences.getInstance();
    seconds = prefs.getBool('seconds') ?? false;
  }
}

class KCalendar extends StatefulWidget {
  const KCalendar({super.key});

  @override
  State<KCalendar> createState() => _KCalendarState();
}

class _KCalendarState extends State<KCalendar> {
  DateTime date = DateTime.now();
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    var calendar = getCalendar();
    return KWidget(Center(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (weekday) {
              return Column(
                  children: List.generate(calendar.length ~/ 7, (week) {
                var day = calendar[weekday + 7 * week];
                return Text('${day > 0 ? day : ""}',
                    style: TextStyle(
                        fontSize: 15,
                        color: (day == date.day)
                            ? Theme.of(context).primaryColor
                            : (weekday == 5 || weekday == 6)
                                ? Theme.of(context).disabledColor
                                : Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color),
                    textAlign: TextAlign.center);
              }));
            }))));
  }

  List<int> getCalendar() {
    var firstWeekday = date.weekday - (date.day % 7);
    firstWeekday = firstWeekday < 0 ? firstWeekday * -1 : firstWeekday;
    var monthes = <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (date.year % 4 == 0) {
      monthes[1]++;
    }
    var monthLength = monthes[date.month - 1];
    var result = <int>[];
    for (var i = 0; i < firstWeekday; i++) {
      result.add(0);
    }
    for (var i = 1; i <= monthLength; i++) {
      result.add(i);
    }
    while (result.length % 7 != 0) {
      result.add(0);
    }
    return result;
  }
}
