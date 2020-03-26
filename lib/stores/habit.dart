import 'package:flutter/material.dart';
import 'package:grass/models/habit.dart';
import 'package:mobx/mobx.dart';

part 'habit.g.dart';

class HabitStore = _BaseStore with _$HabitStore;

/// 基本状态数据
abstract class _BaseStore with Store {
  @observable
  Habit form;

  @action
  Future<void> setForm({@required Habit value}) async {
    form = value;
  }
}
