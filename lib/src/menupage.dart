import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
    body:
          initialized ? ListView(
            children: List.generate(
              apps.length,
              (index) => AppMenuItem(apps[index])
            )
    )  : const Center(child: CircularProgressIndicator()));
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
    return TextButton(
      onPressed: () {
          widget.app.openApp();
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
            });
          },
          child: Icon(
            favorite! ?
              Icons.star : Icons.star_outline),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              editMode = false;
            });
            widget.app.openSettingsScreen();
          },
          child: const Icon(Icons.settings)
        ),
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
    );
  }
}
