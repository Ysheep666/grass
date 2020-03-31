import 'package:grass/models/habit.dart';
import 'package:mobx/mobx.dart';

part 'habit_store.g.dart';

class HabitStore = _HabitStore with _$HabitStore;

/// habit 数据，主要用于 habit 列表
abstract class _HabitStore with Store {
  @observable
  bool isLoaded = false;

  @observable
  List<Habit> items = [];

  @action
  Future<void> save(Habit value) async {
    await Habit.save(value);
    if (value.id == null) {
      items.add(value);
    } else {
      final index = items.indexWhere((h) => h.id == value.id);
      if (index != -1) {
        items[index] = value;
      }
    }
  }

  @action
  Future<void> didLoad() async {
    items = await Habit.getHabits();
    isLoaded = true;
  }
}
