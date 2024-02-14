import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:provider/provider.dart';
import 'data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var favorites = context.watch<Data>().favorites;
    return context.watch<Data>().wallpaper == null
        ? Scaffold(
            body: Center(
                child: CircularProgressIndicator(
                    color: context.watch<Data>().seedColor)))
        : Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MemoryImage(context.watch<Data>().wallpaper!),
                        fit: BoxFit.cover)),
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    children: List.generate(favorites.length,
                        (index) => AppCard(favorites[index])))));
  }
}

class AppCard extends StatefulWidget {
  final String packageName;

  const AppCard(this.packageName, {super.key});

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  ApplicationWithIcon? app;

  void _init() async {
    app = await DeviceApps.getApp(widget.packageName, true)
        as ApplicationWithIcon;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    return app != null
        ? Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: TextButton(
                onPressed: () {
                  app!.openApp();
                },
                onLongPress: () {
                  data.removeFavorite(app!.packageName);
                },
                child: Image.memory(app!.icon)))
        : Center(child: CircularProgressIndicator(color: data.seedColor));
  }

  @override
  initState() {
    super.initState();
    _init();
  }
}
