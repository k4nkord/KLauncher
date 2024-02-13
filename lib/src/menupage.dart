import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:provider/provider.dart';
import 'colorschemepage.dart';
import 'data.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final List<Application> apps;
  bool initialized = false;

  void _init() async {
    apps = (await DeviceApps.getInstalledApplications(includeSystemApps: true, onlyAppsWithLaunchIntent: true))..sort((a, b) => a.appName.compareTo(b.appName));
    setState(() {
      initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var seedColor = context.watch<Data>().seedColor;
    return Scaffold(
    floatingActionButton: FloatingActionButton(onPressed: () {Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ColorSchemePage()));
      },
      child: const Icon(Icons.colorize)
    ), 
    body:
          initialized ? ListView(
            children: List.generate(
              apps.length,
              (index) => AppMenuItem(apps[index])
            )
    )  : Center(child: CircularProgressIndicator(color: seedColor)));
  }

  @override
  initState() {
    super.initState();
    if (!initialized) {
      _init();
    }
  }
}

class AppMenuItem extends StatefulWidget {
  final Application app;

  const AppMenuItem(this.app, {super.key});

  @override
  State<AppMenuItem> createState() => _AppMenuItemState();
}

class _AppMenuItemState extends State<AppMenuItem> {
  bool editMode = false;
  bool? favorite;

  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    favorite ??= data.isFavorite(widget.app.packageName);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextButton(
      onPressed: () {
          widget.app.openApp();
          data.setPage(0);
      },
      onLongPress: () {
        setState(() {
          editMode = !editMode;
        });
      },
      child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: editMode ? 
      [
        TextButton(
          onPressed: () {
            if (favorite!) {
              data.removeFavorite(widget.app.packageName);
            } else {
              data.addFavorite(widget.app.packageName);
            }
            setState(() {
              favorite = !favorite!;
              editMode = !editMode;
            });
          },
          child: Icon(
            favorite! ?
              Icons.star : Icons.star_outline),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () {
            setState(() {
              editMode = false;
            });
            widget.app.openSettingsScreen();
            data.setPage(0);
          },
          child: const Icon(Icons.settings)
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () {
            setState(() {
              editMode = false;
            });
            widget.app.uninstallApp();
          },
          child: const Icon(Icons.delete)
        )
      ]
      : [
      Text(
        widget.app.appName,
      ),
      ])
    ));
  }
}
