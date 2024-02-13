import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:provider/provider.dart';
import 'data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<String>> loadApps(Data data) async {
    var favorites = data.favorites;
    bool edited = false;
    for (var packageName in favorites) {
      if (!await DeviceApps.isAppInstalled(packageName)) {
        favorites.remove(packageName);
        edited = true;
      }
    }
    if (edited) {
      data.favorites = favorites;
    }
    return favorites;
  }

  @override
  Widget build(BuildContext context) {
    var seedColor = context.watch<Data>().seedColor;
    return Scaffold(
      body: FutureBuilder(
      future: loadApps(context.watch<Data>()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: seedColor));
        }
        return GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        children: List.generate(
          (snapshot.data as List<String>).length,
          (index) => AppCard(snapshot.data![index])
        )
      );
      })
    ); 
  }
}

class AppCard extends StatefulWidget {
  final String packageName;

  const AppCard(this.packageName, {super.key});

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  late ApplicationWithIcon app;
  bool initialized = false;

  void _init() async {
    app = (await DeviceApps.getApp(widget.packageName, true)) as ApplicationWithIcon;
    setState(() {
      initialized = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    var seedColor = data.seedColor;
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(7.5),
      ),
          child: TextButton(
            onPressed: () {
              app.openApp();
            },
            onLongPress: () {
              data.removeFavorite(app.packageName);
            },
            child: initialized ? Image.memory(app.icon) : CircularProgressIndicator(color: seedColor)
          ));
  }

  @override
  initState() {
    super.initState();
    _init();
  }
}
