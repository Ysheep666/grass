import 'package:grass/models/habit.dart';
import 'package:grass/models/habit_record.dart';
import 'package:grass/models/motion_group_record.dart';
import 'package:grass/models/motion_record.dart';
import 'package:grass/utils/diff.dart';
import 'package:mobx/mobx.dart';

part 'habit_detail_store.g.dart';

class HabitDetailStore = _HabitDetailStore with _$HabitDetailStore;

/// habit 详细数据，主要用于 habit_detail 页面
abstract class _HabitDetailStore with Store {
  @observable
  bool isLoaded = false;

  @observable
  Habit habit;

  @observable
  HabitRecord record;

  @observable
  ObservableList<MotionRecord> motionRecords = ObservableList<MotionRecord>();

  @observable
  ObservableList<MotionGroupRecord> motionGroupRecords = ObservableList<MotionGroupRecord>();

  @action
  Future<void> didLoad(Habit value) async {
    habit = value;
    HabitRecord _record = await HabitRecord.getLastByHabitId(habit.id);
    if (_record == null) {
      _record = HabitRecord();
      _record.id = await _record.save();
      record = _record;
    } else if (_record.isDone) {

    } else {
      record = _record;
      final _motionRecords = await MotionRecord.getItemsByHabitRecordId(record.id);
      _updateMotionRecords(_motionRecords);
      final _motionGroupRecords = await MotionGroupRecord.getItemsByMotionRecordIds(_motionRecords.map((e) => e.id).toList());
      _updateMotionGroupRecords(_motionGroupRecords);
    }
    isLoaded = true;
  }

  _updateMotionRecords(List<MotionRecord> items) {
    final diff = ListDiff<MotionRecord>(motionRecords, items);
    final ots = diff.getOt();
    int index = 0;
    for (var i = 0; i < ots.length; i++) {
      final ot = ots[i];
      if (ot.type == OperationType.add) {
        motionRecords.insert(i, ot.newValue);
      } else if (ot.type == OperationType.remove) {
        motionRecords.removeAt(i + index);
        index -= 1;
      } else {
        motionRecords[i + index] = ot.newValue;
      }
    }
  }

  _updateMotionGroupRecords(List<MotionGroupRecord> items) {
    final diff = ListDiff<MotionGroupRecord>(motionGroupRecords, items);
    final ots = diff.getOt();
    int index = 0;
    for (var i = 0; i < ots.length; i++) {
      final ot = ots[i];
      if (ot.type == OperationType.add) {
        motionGroupRecords.insert(i, ot.newValue);
      } else if (ot.type == OperationType.remove) {
        motionGroupRecords.removeAt(i + index);
        index -= 1;
      } else {
        motionGroupRecords[i + index] = ot.newValue;
      }
    }
  }
}
