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
  Map<String, List<Application>> apps = {};
  bool initialized = false;

  void _init() async {
    var xs = await DeviceApps.getInstalledApplications(
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
        includeAppIcons: true)
      ..sort(
          (a, b) => a.appName.toUpperCase().compareTo(b.appName.toUpperCase()));
    var key = '';
    for (var app in xs) {
      var firstLetter = app.appName[0].toUpperCase();
      if (int.tryParse(firstLetter) != null ||
          [
            '\$',
            '@',
            '%',
            '!',
            '~',
            '`',
            '№',
            '"',
            '\'',
            '/',
            '\\',
            '*',
            '&',
            '^',
            '(',
            ')',
            '-',
            '_',
            '+',
            '='
          ].contains(firstLetter)) {
        firstLetter = '#';
      }
      if (key != firstLetter) {
        key = firstLetter;
        apps[key] = [];
      }
      apps[key]!.add(app);
    }
    setState(() {
      initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var keys = apps.keys.toList();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ColorSchemePage()));
            },
            child: const Icon(Icons.colorize)),
        body: initialized
            ? ListView(
                children: List.generate(keys.length, (index) {
                return AppGroup(keys[index], apps[keys[index]]!);
              }))
            : Center(
                child: CircularProgressIndicator(
                    color: context.watch<Data>().seedColor)));
  }

  @override
  initState() {
    super.initState();
    _init();
  }
}

class AppGroup extends StatefulWidget {
  final String letter;
  final List<Application> apps;

  const AppGroup(this.letter, this.apps, {super.key});

  @override
  State<AppGroup> createState() => _AppGroupState();
}

class _AppGroupState extends State<AppGroup> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 30,
              height: 35,
              decoration: BoxDecoration(color: context.watch<Data>().seedColor),
              child: Text(widget.letter,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center)),
          Column(
              children: List.generate(
                  widget.apps.length,
                  (index) =>
                      MenuCard(widget.apps[index] as ApplicationWithIcon)))
        ]);
  }
}

class MenuCard extends StatefulWidget {
  final ApplicationWithIcon app;

  const MenuCard(this.app, {super.key});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool editMode = false;
  bool? favorite;

  @override
  Widget build(BuildContext context) {
    favorite ??= context.watch<Data>().isFavorite(widget.app.packageName);
    var data = context.watch<Data>();
    return Column(children: [
      Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(7.5),
          ),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextButton(
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
                      children: (editMode
                          ? [
                              TextButton(
                                  onPressed: () {
                                    if (favorite!) {
                                      data.removeFavorite(
                                          widget.app.packageName);
                                    } else {
                                      data.addFavorite(widget.app.packageName);
                                    }
                                    setState(() {
                                      favorite = !favorite!;
                                      editMode = false;
                                    });
                                  },
                                  child: favorite!
                                      ? const Icon(Icons.star)
                                      : const Icon(Icons.star_outline)),
                              const SizedBox(width: 5),
                              TextButton(
                                  onPressed: () {
                                    widget.app.openSettingsScreen();
                                    data.setPage(0);
                                  },
                                  child: const Icon(Icons.settings)),
                              const SizedBox(width: 5),
                              TextButton(
                                  onPressed: () {
                                    widget.app.uninstallApp();
                                    data.setPage(0);
                                  },
                                  child: const Icon(Icons.delete))
                            ]
                          : [
                              Text(widget.app.appName,
                                  textAlign: TextAlign.center)
                            ])
                        ..insert(
                            0,
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Image.memory(widget.app.icon,
                                    width: 45, height: 45)))))))
    ]);
  }
}
