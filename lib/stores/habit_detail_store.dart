import 'dart:async';

import 'package:grass/models/habit.dart';
import 'package:grass/models/habit_record.dart';
import 'package:grass/models/motion.dart';
import 'package:grass/models/motion_group_record.dart';
import 'package:grass/models/motion_record.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/diff.dart';
import 'package:mobx/mobx.dart';

part 'habit_detail_store.g.dart';

class HabitDetailStore = _HabitDetailStore with _$HabitDetailStore;

/// habit 详细数据，主要用于 habit_detail 页面
abstract class _HabitDetailStore with Store {
  Timer _timer;
  bool _lock = false;

  @observable
  bool isLoaded = false;

  @observable
  Habit habit;

  @observable
  HabitRecord record;

  @observable
  List<Motion> motions = [];

  @observable
  ObservableList<MotionRecord> motionRecords = ObservableList<MotionRecord>();

  @observable
  ObservableList<MotionGroupRecord> motionGroupRecords = ObservableList<MotionGroupRecord>();

  @action
  Future<void> didLoad(Habit value) async {
    habit = value;
    HabitRecord habiRecord = await HabitRecord.getLastByHabitId(habit.id);
    if (habiRecord == null) {
      habiRecord = HabitRecord(habitId: habit.id);
      habiRecord.id = await habiRecord.save();
      record = habiRecord;
    } else if (habiRecord.isDone) {

    } else {
      record = habiRecord;
      final newMotionRecords = await MotionRecord.getItemsByHabitRecordId(record.id);
      await _updateMotionRecords(newMotionRecords);
      final _motionGroupRecords = await MotionGroupRecord.getItemsByMotionRecordIds(newMotionRecords.map((e) => e.id).toList());
      await _updateMotionGroupRecords(_motionGroupRecords);
    }
    isLoaded = true;
  }

  @action
  Future<void> clear() async {
    isLoaded = false;
    habit = null;
    record = null;
    motions = [];
    motionRecords = ObservableList<MotionRecord>();
    motionGroupRecords = ObservableList<MotionGroupRecord>();
  }

  @action
  Future<void> addMotionsByIds(List<int> motionIds) async {
    final newMotions = await NativeMethod.getMotionsByIds(motionIds);
    final newMotionRecords = await MotionRecord.batchAdd(
      motionIds.map((id) => MotionRecord(motionId: id, habitRecordId: record.id)).toList()
    );
    final newMotionGroupRecords = await MotionGroupRecord.batchAdd(
      newMotionRecords.map((r) => MotionGroupRecord(
        motionRecordId: r.id,
        content: newMotions.firstWhere((m) => m.id == r.motionId).content
      )).toList()
    );
    motions.addAll(newMotions);
    for (var motionRecord in newMotionRecords) {
      motionRecords.add(motionRecord);
    }
    for (var motionGroupRecord in newMotionGroupRecords) {
      motionGroupRecords.add(motionGroupRecord);
    }
  }

  @action
  Future<void> addMotionGroupRecord(MotionGroupRecord motionGroupRecord) async {
    motionGroupRecord.id = await motionGroupRecord.save();
    motionGroupRecords.add(motionGroupRecord);
  }

  @action
  Future<void> removeMotionGroupRecord(MotionGroupRecord motionGroupRecord) async {
    final result = await motionGroupRecord.delete();
    if (result != -1) {
      motionGroupRecords.remove(motionGroupRecord);
    }
  }

  @action
  Future<void> updateMotionGroupRecord(MotionGroupRecord motionGroupRecord) async {
    final newmMotionGroupRecord = motionGroupRecord.copy();
    final index = motionGroupRecords.indexWhere((r) => r.id == newmMotionGroupRecord.id);
    if (index != -1) {
      motionGroupRecords[index] = newmMotionGroupRecord;
    }
    _updateTo();
  }

  _updateTo() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 1), () async {
      if (_lock) {
        Future.delayed(Duration(seconds: 1), () => _updateTo());
      } else {
        _lock = true;
        await MotionRecord.batchUpdate(motionRecords);
        await MotionGroupRecord.batchUpdate(motionGroupRecords);
        _lock = false;
      }
    });
  }

  _updateMotionRecords(List<MotionRecord> items) async {
    motions = await NativeMethod.getMotionsByIds(items.map((e) => e.motionId).toList());
    final diff = ListDiff<MotionRecord>(motionRecords, items);
    final ots = diff.getOT();
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

  _updateMotionGroupRecords(List<MotionGroupRecord> items) async {
    final diff = ListDiff<MotionGroupRecord>(motionGroupRecords, items);
    final ots = diff.getOT();
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
