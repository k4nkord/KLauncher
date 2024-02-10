import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_apps/device_apps.dart';
import 'kconfigpage.dart';

class KHomePage extends StatefulWidget {
  const KHomePage({super.key});

  @override
  State<KHomePage> createState() => _KHomePageState();
}

class _KHomePageState extends State<KHomePage> {
  List<String> favorite = [];
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      initialized ? 
        ListView(children: List.generate(
        favorite.length,
        (index) => AppCard(favorite[index])
      )..insert(0, const SizedBox(height: 100)))
      : Center(child: CircularProgressIndicator(color: Theme.of(context).textTheme.bodyMedium!.color)));
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    var prefs = await SharedPreferences.getInstance();
    favorite = prefs.getStringList('favorite') ?? await openConfigPage();
    setState(() {
      initialized = true;
    });
  }

  Future<dynamic> openConfigPage() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => const KConfigPage()));
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
