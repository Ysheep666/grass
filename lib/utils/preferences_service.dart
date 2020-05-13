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
  SharedPreferences sharedPreferences;

  static const String _useDarkModeKey = 'useDarkMode';
  static const String _weightUnitKey = 'weightUnit';
  static const String _distanceUnitKey = 'distanceUnit';

  set useDarkMode(ThemeMode mode) {
    sharedPreferences.setString(_useDarkModeKey, mode.toString());
  }

  ThemeMode get useDarkMode {
    final mode = sharedPreferences.getString(_useDarkModeKey);
    if (mode == null) {
      return ThemeMode.light;
    }
    return ThemeMode.values.firstWhere((e) => e.toString() == mode);
  }

  set weightUnit(WeightUnit unit) {
    sharedPreferences.setString(_weightUnitKey, unit.toString());
  }

  WeightUnit get weightUnit {
    final unit = sharedPreferences.getString(_weightUnitKey);
    if (unit == null) {
      return WeightUnit.kg;
    }
    return WeightUnit.values.firstWhere((e) => e.toString() == unit);
  }

  set distanceUnit(DistanceUnit unit) {
    sharedPreferences.setString(_distanceUnitKey, unit.toString());
  }

  DistanceUnit get distanceUnit {
    final unit = sharedPreferences.getString(_distanceUnitKey);
    if (unit == null) {
      return DistanceUnit.km;
    }
    return DistanceUnit.values.firstWhere((e) => e.toString() == unit);
  }

  Future<void> _loadPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
