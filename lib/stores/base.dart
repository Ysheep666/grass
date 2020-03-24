import 'package:flutter/material.dart';
import 'package:grass/utils/preferences_service.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'base.g.dart';

// This is the class used by rest of your codebase
class BaseStore = _BaseStore with _$BaseStore;

// The store-class
/// 基本状态数据
abstract class _BaseStore with Store {
  _BaseStore(this._preferencesService) {
    _setup();
  }

  final PreferencesService _preferencesService;

  /// 主题管理
  @observable
  ThemeMode useDarkMode = ThemeMode.system;

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
