import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService() {
    loaded = _loadPreferences();
  }

  Future<void> loaded;

  static const String _useDarkModeKey = 'useDarkMode';
  SharedPreferences _sharedPreferences;

  set useDarkMode(ThemeMode useDarkMode) {
    _sharedPreferences.setString(_useDarkModeKey, useDarkMode.toString());
  }

  ThemeMode get useDarkMode {
    final darkMode = _sharedPreferences.getString(_useDarkModeKey);
    if (darkMode == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values.firstWhere((e) => e.toString() == darkMode);
  }

  Future<void> _loadPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}
