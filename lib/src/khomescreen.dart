import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_apps/device_apps.dart';
import 'kconfigscreen.dart';
//import 'notespage.dart';
import 'widgetspage.dart';

class KHomeScreen extends StatefulWidget {
  const KHomeScreen({super.key});

  @override
  State<KHomeScreen> createState() => _KHomeScreenState();
}

class _KHomeScreenState extends State<KHomeScreen> {
  List<String> favorite = [];
  bool initialized = false;
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      initialized ? 
      PageView(controller: controller, children: [
        /*const NotesPage(), */ListView(children: List.generate(
        favorite.length,
        (index) => AppCard(favorite[index])
      )..insert(0, const SizedBox(height: 100))), const WidgetsPage()])
      : Center(child: CircularProgressIndicator(color: Theme.of(context).textTheme.bodyMedium!.color)));
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    var prefs = await SharedPreferences.getInstance();
    favorite = prefs.getStringList('favorite') ?? await openConfigScreen(context);
    setState(() {
      initialized = true;
    });
  }
}

class AppCard extends StatefulWidget {
  final String packageName;

  const AppCard(this.packageName, {super.key});

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  String appName = '';

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (appName != '') {
          DeviceApps.openApp(widget.packageName);
        }
      },
      onLongPress: () {
        DeviceApps.uninstallApp(widget.packageName);
      },
      child: Text(
        appName,
        style: Theme.of(context).textTheme.bodyMedium
      ));
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    var name = (await DeviceApps.getApp(widget.packageName))?.appName;
    if (name == null) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setStringList('favorites',
        prefs.getStringList('favorites')!..remove(widget.packageName));
    } else {
      appName = name;
    }
    setState(() {});
  }
}
