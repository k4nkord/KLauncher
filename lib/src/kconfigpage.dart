import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';
  
List<String> favorite = [];

class KConfigPage extends StatefulWidget {
  const KConfigPage({super.key});

  @override
  State<KConfigPage> createState() => _KConfigPageState();
}

class _KConfigPageState extends State<KConfigPage> {
  List<Application> apps = [];
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        saveFavorites();
        Navigator.pop(context, favorite);
      },
      child: const Icon(Icons.done)
    ),
    body: 
    Center(child: initialized
    ? 
        ListView(children: List.generate(apps.length, (index) {
          return AppCheckbox(apps[index]);
        }))
    : CircularProgressIndicator(color: Theme.of(context).textTheme.bodyMedium!.color)));
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    apps = (await DeviceApps.getInstalledApplications(includeSystemApps: true, onlyAppsWithLaunchIntent: true))..sort((a, b) => a.appName.compareTo(b.appName));
    setState(() {
      initialized = true;
    });
  }

  void saveFavorites() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorite', favorite);
  }
}

class AppCheckbox extends StatefulWidget {
  final Application app;

  const AppCheckbox(this.app, {super.key});

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  bool choosen = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (choosen) {
          favorite.remove(widget.app.packageName);
        } else {
          favorite.add(widget.app.packageName);
        }
        setState(() {
          choosen = !choosen;
        });
      },
      child: Text(
        widget.app.appName, 
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: choosen ? Theme.of(context).shadowColor : Theme.of(context).textTheme.bodyMedium!.color),
        textAlign: TextAlign.center
      )
    );
  }
}
