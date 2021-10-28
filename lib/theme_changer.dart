import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeChangerClass with ChangeNotifier {
  SharedPreferences _prefs;
  String _version;
  ThemeChangerClass(SharedPreferences _p, String v) {
    _prefs = _p;
    _version = v;
  }

  get version => _version;
  get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _prefs.getBool('isDarkMode') ?? false;
  set isDarkMode(bool _dark) {
    _prefs.setBool('isDarkMode', _dark);
    notifyListeners();
  }
}

