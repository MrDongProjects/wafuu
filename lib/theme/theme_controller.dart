import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  late SharedPreferences _prefs;
  bool _isDarkMode = false;
  ThemeMode _themeMode = ThemeMode.light;
  bool _initialized = false;

  ThemeController() {
    _initAsync();
  }

  Future<void> _initAsync() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(_themeKey) ?? false;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _initialized = true;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _themeMode;

  Future<void> toggleTheme() async {
    if (!_initialized) await _initAsync();
    _isDarkMode = !_isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
