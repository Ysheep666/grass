import 'package:flutter/material.dart';
import 'package:grass/utils/preferences_service.dart';
import 'package:mobx/mobx.dart';

part 'base.g.dart';

class BaseStore = _BaseStore with _$BaseStore;

/// 基本状态数据
abstract class _BaseStore with Store {
  _BaseStore(this._preferencesService) {
    _setup();
  }

  final PreferencesService _preferencesService;

  /// 主题管理
  @observable
  ThemeMode useDarkMode = ThemeMode.light;

  @action
  Future<void> setDarkMode({@required ThemeMode value}) async {
    await _preferencesService.loaded;
    _preferencesService.useDarkMode = value;
    useDarkMode = value;
  }

  Future<void> _setup() async {
    await _preferencesService.loaded;
    useDarkMode = _preferencesService.useDarkMode;
  }
}
