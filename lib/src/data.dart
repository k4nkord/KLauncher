import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data with ChangeNotifier {
  List<String> _favorites = [];
  bool _darkTheme = true;
  Color _seedColor = Colors.white;
  Color _secondaryColor = const Color(0xff222222);

  Data() {
    _init();
  }

  List<String> get favorites => _favorites;
  set favorites (List<String> favorites) {
    _favorites = favorites;
    saveData('favorites', _favorites);
    notifyListeners();
  }

  bool get darkTheme => _darkTheme;
  set darkTheme (bool theme) {
    _darkTheme = theme;
    saveData('darkTheme', _darkTheme);
    notifyListeners();
  }

  Color get seedColor => _seedColor;
  set seedColor (Color color) {
    _seedColor = color;
    saveData('seedColor', _seedColor.value);
    notifyListeners();
  }

  Color get secondaryColor => _secondaryColor;
  set secondaryColor (Color color) {
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
    _darkTheme = prefs.getBool('darkTheme') ?? true;
    _seedColor = Color(prefs.getInt('seedColor') ?? _seedColor.value);
    _secondaryColor = Color(prefs.getInt('secondaryColor') ?? _secondaryColor.value);
    notifyListeners();
  }
}
