import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:access_wallpaper/access_wallpaper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_apps/device_apps.dart';

class Data with ChangeNotifier {
  List<String> _favorites = [];
  bool _darkTheme = true;
  Color _seedColor = Colors.white;
  Color _secondaryColor = const Color(0xff222222);
  PageController controller = PageController();
  Uint8List? wallpaper;

  Data() {
    _init();
  }

  List<String> get favorites => _favorites;
  set favorites(List<String> favorites) {
    _favorites = favorites;
    saveData('favorites', _favorites);
    notifyListeners();
  }

  bool get darkTheme => _darkTheme;
  set darkTheme(bool theme) {
    _darkTheme = theme;
    saveData('darkTheme', _darkTheme);
    notifyListeners();
  }

  Color get seedColor => _seedColor;
  set seedColor(Color color) {
    _seedColor = color;
    saveData('seedColor', _seedColor.value);
    notifyListeners();
  }

  Color get secondaryColor => _secondaryColor;
  set secondaryColor(Color color) {
    _secondaryColor = color;
    saveData('secondaryColor', _secondaryColor.value);
    notifyListeners();
  }

  void addFavorite(String packageName) {
    _favorites.add(packageName);
    saveData('favorites', _favorites);
    notifyListeners();
  }

  void removeFavorite(String packageName) {
    _favorites.remove(packageName);
    saveData('favorites', _favorites);
    notifyListeners();
  }

  void setPage(int page) {
    controller.jumpToPage(page);
  }

  double get page => controller.page ?? 0.0;

  bool isFavorite(String packageName) => _favorites.contains(packageName);

  void saveData(String key, dynamic data) async {
    var prefs = await SharedPreferences.getInstance();
    if (data is List<String>) {
      prefs.setStringList(key, data);
    } else if (data is bool) {
      prefs.setBool(key, data);
    } else if (data is int) {
      prefs.setInt(key, data);
    }
  }

  void _init() async {
    var prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites') ?? [];
    checkFavorites();
    _darkTheme = prefs.getBool('darkTheme') ?? true;
    _seedColor = Color(prefs.getInt('seedColor') ?? _seedColor.value);
    _secondaryColor =
        Color(prefs.getInt('secondaryColor') ?? _secondaryColor.value);
    loadWallpaper();
    notifyListeners();
  }

  void checkFavorites() async {
    var bad = [];
    for (var packageName in _favorites) {
      if (!await DeviceApps.isAppInstalled(packageName)) {
        bad.add(packageName);
      }
    }
    for (var packageName in bad) {
      _favorites.remove(packageName);
    }
    if (bad.isNotEmpty) {
      notifyListeners();
    }
  }

  void loadWallpaper() async {
    await Permission.manageExternalStorage.request();
    if (await Permission.manageExternalStorage.isGranted) {
      wallpaper =
          await AccessWallpaper().getWallpaper(AccessWallpaper.homeScreenFlag);
    }
    notifyListeners();
  }
}
