import 'package:flutter/material.dart';
import 'package:grass/models/motion_content.dart';
import 'package:grass/utils/preferences_service.dart';
import 'package:mobx/mobx.dart';

part 'base_store.g.dart';

class BaseStore = _BaseStore with _$BaseStore;

/// 基本状态数据
abstract class _BaseStore with Store {
  _BaseStore(this._preferencesService) {
    _setup();
  }

  /// 路由管理
  @observable
  RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  final PreferencesService _preferencesService;

  /// 主题管理
  @observable
  ThemeMode useDarkMode = ThemeMode.light;

  @action
  Future<void> setDarkMode(ThemeMode value) async {
    await _preferencesService.loaded;
    _preferencesService.useDarkMode = value;
    useDarkMode = value;
  }

  Future<void> _setup() async {
    await _preferencesService.loaded;
    useDarkMode = _preferencesService.useDarkMode;
  }

  String getMotionCategoryLabel(MotionCategory category) {
    switch (category) {
      case MotionCategory.weight:
        return WeightUnitEnumMap[_preferencesService.weightUnit];
      case MotionCategory.distance:
        return DistanceUnitEnumMap[_preferencesService.distanceUnit];
      case MotionCategory.number:
        return '次';
      case MotionCategory.duration:
        return '时间';
      default:
        return '';
    }
  }
}
