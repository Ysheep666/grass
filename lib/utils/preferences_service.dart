import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum WeightUnit {
  kg,
  lbs,
}

const WeightUnitEnumMap = {
  WeightUnit.kg: 'kg',
  WeightUnit.lbs: 'lbs',
};

enum DistanceUnit {
  km,
  ft,
}

const DistanceUnitEnumMap = {
  DistanceUnit.km: 'km',
  DistanceUnit.ft: 'ft',
};

class PreferencesService {
  PreferencesService() {
    loaded = _loadPreferences();
  }

  Future<void> loaded;

  static const String _useDarkModeKey = 'useDarkMode';
  static const String _weightUnitKey = 'weightUnit';
  static const String _distanceUnitKey = 'distanceUnit';
  SharedPreferences _sharedPreferences;

  set useDarkMode(ThemeMode mode) {
    _sharedPreferences.setString(_useDarkModeKey, mode.toString());
  }

  ThemeMode get useDarkMode {
    final mode = _sharedPreferences.getString(_useDarkModeKey);
    if (mode == null) {
      return ThemeMode.light;
    }
    return ThemeMode.values.firstWhere((e) => e.toString() == mode);
  }

  set weightUnit(WeightUnit unit) {
    _sharedPreferences.setString(_weightUnitKey, unit.toString());
  }

  WeightUnit get weightUnit {
    final unit = _sharedPreferences.getString(_weightUnitKey);
    if (unit == null) {
      return WeightUnit.kg;
    }
    return WeightUnit.values.firstWhere((e) => e.toString() == unit);
  }

  set distanceUnit(DistanceUnit unit) {
    _sharedPreferences.setString(_distanceUnitKey, unit.toString());
  }

  DistanceUnit get distanceUnit {
    final unit = _sharedPreferences.getString(_distanceUnitKey);
    if (unit == null) {
      return DistanceUnit.km;
    }
    return DistanceUnit.values.firstWhere((e) => e.toString() == unit);
  }

  Future<void> _loadPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}
