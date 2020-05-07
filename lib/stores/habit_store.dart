import 'package:grass/models/habit.dart';
import 'package:grass/utils/diff.dart';
import 'package:grass/utils/helper.dart';
import 'package:mobx/mobx.dart';

part 'habit_store.g.dart';

class HabitStore = _HabitStore with _$HabitStore;

/// habit 数据，主要用于 habit 页面
abstract class _HabitStore with Store {
  List<Habit> _allHabits = [];

  @observable
  bool isLoaded = false;

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  ObservableList<Habit> habits = ObservableList<Habit>();

  @action
  setSelectedDate(DateTime value) {
    selectedDate = value;
    _updateHabits();
  }

  @action
  Future<void> didLoad() async {
    _allHabits = await Habit.getItems();
    isLoaded = true;
    _updateHabits();
  }

  @action
  Future<void> save(Habit habit) async {
    final isAdd = habit.id == null;
    habit.id = await habit.save();
    if (isAdd) {
      _allHabits.add(habit);
    } else {
      final index = _allHabits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _allHabits[index] = habit;
      }
    }
    _updateHabits();
  }

  @action
  Future<void> remove(Habit habit) async {
    await habit.delete();
    _allHabits.remove(habit);
    _updateHabits();
  }

  bool _isSelectedAtHabit(Habit value) {
    if (value.isArchived) {
      return false;
    }
    if (value.repeatStatusType != HabitRepeatStatusType.custom) {
      return value.repeatStatusValues.indexOf(selectedDate.weekday - 1) != -1;
    }
    final diffDay = calculateDifference(selectedDate, value.createdDate).abs();
    return diffDay % (value.repeatStatusValues[0] + 1) == 0;
  }

  _updateHabits() {
    final newItems = _allHabits
      .where((i) => _isSelectedAtHabit(i))
      .toList()
      ..sort((a, b) => a.updatedDate.difference(b.updatedDate).inMicroseconds > 0 ? -1 : 1);

    final diff = ListDiff<Habit>(habits, newItems);
    final ots = diff.getOT();
    int index = 0;
    for (var i = 0; i < ots.length; i++) {
      final ot = ots[i];
      if (ot.type == OperationType.add) {
        habits.insert(i, ot.newValue);
      } else if (ot.type == OperationType.remove) {
        habits.removeAt(i + index);
        index -= 1;
      } else {
        habits[i + index] = ot.newValue;
      }
    }
  }
}
