import 'package:grass/models/habit.dart';
import 'package:grass/utils/diff.dart';
import 'package:grass/utils/helper.dart';
import 'package:mobx/mobx.dart';

part 'habit_store.g.dart';

class HabitStore = _HabitStore with _$HabitStore;

/// habit 数据，主要用于 habit 列表
abstract class _HabitStore with Store {
  List<Habit> _allItems = [];

  @observable
  bool isLoaded = false;

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  ObservableList<Habit> items = ObservableList<Habit>();

  @action
  setSelectedDate(DateTime value) {
    selectedDate = value;
    _updateAllItems();
  }

  @action
  Future<void> didLoad() async {
    _allItems = await Habit.getHabits();
    _updateAllItems();
    isLoaded = true;
  }

  @action
  Future<void> save(Habit value) async {
    await Habit.save(value);
    if (value.id == null) {
      _allItems.add(value);
      if (_isSelectedAtHabit(value)) {
        items.add(value);
      }
    } else {
      final index = _allItems.indexWhere((h) => h.id == value.id);
      if (index != -1) {
        _allItems[index] = value;
      }

      if (_isSelectedAtHabit(value)) {
        final observableListIndex = items.indexWhere((h) => h.id == value.id);
        if (observableListIndex != -1) {
          items[observableListIndex] = value;
        }
      } else {
        items.remove(value);
      }
    }
  }

  @action
  Future<void> remove(Habit value) async {
    await Habit.delete(value.id);
    _allItems.remove(value);
    items.remove(value);
  }

  bool _isSelectedAtHabit(Habit value) {
    if (value.isArchived) {
      return false;
    }
    if (value.repeatStatusType != HabitRepeatStatusType.custom) {
      return value.repeatStatusValues.indexOf(selectedDate.weekday - 1) != -1;
    }
    final diffDay = calculateDifference(selectedDate, value.createdDate).abs();
    return value.repeatStatusValues[0] == diffDay;
  }

  _updateAllItems() {
    final newItems = _allItems
      .where((i) => _isSelectedAtHabit(i))
      .toList()
      ..sort((a, b) => a.updatedDate.difference(b.updatedDate).inMicroseconds > 0 ? -1 : 1);

    final diff = ListDiff<Habit>(items, newItems);
    final ots = diff.getOt();
    int index = 0;
    for (var i = 0; i < ots.length; i++) {
      final ot = ots[i];
      if (ot.type == OperationType.add) {
        items.insert(i, ot.newValue);
      } else if (ot.type == OperationType.remove) {
        items.removeAt(i + index);
        index -= 1;
      } else {
        items[i + index] = ot.newValue;
      }
    }
  }
}
