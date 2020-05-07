import 'dart:async';

import 'package:grass/models/habit.dart';
import 'package:grass/models/habit_record.dart';
import 'package:grass/models/motion.dart';
import 'package:grass/models/motion_content.dart';
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
  List<MotionRecord> _lastMotionRecords = [];
  List<MotionGroupRecord> _lastMotionGroupRecords = [];

  @observable
  bool isLoaded = false;

  @observable
  bool isContinue = false;

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
    final habitRecords = await HabitRecord.getLastByHabitId(habit.id);
    if (habitRecords.isEmpty) {
      await _createHabitRecord();
    } else {
      final savedMotionRecords = await MotionRecord.getItemsByHabitRecordId(
        habitRecords.first.isDone ? [habitRecords.first.id] : habitRecords.map((e) => e.id).toList()
      );
      final savedMotionGroupRecords = await MotionGroupRecord.getItemsByMotionRecordIds(savedMotionRecords.map((e) => e.id).toList());
      if (habitRecords.first.isDone) {
        _lastMotionRecords = savedMotionRecords;
        _lastMotionGroupRecords = savedMotionGroupRecords;
        await _createHabitRecord();
      } else {
        isContinue = true;
        record = habitRecords.first;

        _lastMotionRecords = savedMotionRecords.where((c) => c.habitRecordId != record.id).toList();
        _lastMotionGroupRecords = savedMotionGroupRecords.where((c) => _lastMotionRecords.indexWhere((m) => m.id == c.motionRecordId) != -1).toList();

        await _updateMotionRecords(savedMotionRecords.where((c) => c.habitRecordId == record.id).toList());
        await _updateMotionGroupRecords(savedMotionGroupRecords.where((c) => motionRecords.indexWhere((m) => m.id == c.motionRecordId) != -1).toList());
      }
    }
    isLoaded = true;
  }

  @action
  Future<void> clear() async {
    _timer = null;
    _lock = false;
    _lastMotionRecords = [];
    _lastMotionGroupRecords = [];
    isLoaded = false;
    isContinue = false;
    habit = null;
    record = null;
    motions = [];
    motionRecords = ObservableList<MotionRecord>();
    motionGroupRecords = ObservableList<MotionGroupRecord>();
  }

  @action
  Future<void> reset() async {
    record.isArchived = true;
    await record.save();
    await _createHabitRecord();
  }

  @action
  Future<void> addMotionRecordsByMotionIds(List<int> motionIds) async {
    final newMotions = await NativeMethod.getMotionsByIds(motionIds);
    final newMotionRecords = await MotionRecord.batchAdd(
      motionIds
        .asMap().entries
        .map((entry) => MotionRecord(
          motionId: entry.value,
          habitRecordId: record.id,
          sortIndex: motionRecords.length + entry.key,
        ))
        .toList()
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
  Future<void> removeMotionRecord(MotionRecord motionRecord) async {
    final result = await motionRecord.delete();
    if (result != -1) {
      motionRecords.remove(motionRecord);
    }
  }

  @action
  Future<void> moveMotionRecord(int from, int to) async {
    final motionRecord = motionRecords[from];
    motionRecords.removeAt(from);
    motionRecords.insert(to, motionRecord);
    _updateTo();
  }

  @action
  Future<void> addMotionGroupRecord(Motion motion, int motionRecordId) async {
    List<MotionContent> content = motion.content;
    final lastIndex = motionGroupRecords.lastIndexWhere((g) => g.motionRecordId == motionRecordId);
    if (lastIndex != -1) {
      content = motionGroupRecords[lastIndex].content.map((c) => MotionContent(
        category: c.category,
        defaultValue: c.value ?? c.defaultValue,
      )).toList();
    }

    final motionGroupRecord = MotionGroupRecord(
      motionRecordId: motionRecordId,
      content: content,
    );
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
    final newmMotionGroupRecord = motionGroupRecord.copyAndCreated();
    final index = motionGroupRecords.indexWhere((r) => r.id == newmMotionGroupRecord.id);
    if (index != -1) {
      motionGroupRecords[index] = newmMotionGroupRecord;
    }
    _updateTo();
  }

  @action
  Future<void> submit() async {
    List<MotionRecord> discardMotionRecords = [];
    List<MotionGroupRecord> discardMotionGroupRecords = [];
    List<MotionGroupRecord> saveMotionGroupRecords = [];
    for (var motionGroupRecord in motionGroupRecords) {
      if (motionGroupRecord.isDone || motionGroupRecord.isEffective) {
        motionGroupRecord.isDone = true;
        saveMotionGroupRecords.add(motionGroupRecord);
      } else {
        discardMotionGroupRecords.add(motionGroupRecord);
      }
    }

    discardMotionRecords = motionRecords.where((r) => saveMotionGroupRecords.indexWhere((g) => g.motionRecordId == r.id) == -1).toList();

    await MotionGroupRecord.batchDelete(discardMotionGroupRecords);
    await MotionGroupRecord.batchUpdate(saveMotionGroupRecords);
    await MotionRecord.batchDelete(discardMotionRecords);

    record.isDone = true;
    await record.save();
  }

  _createHabitRecord() async {
    final habiRecord = HabitRecord(habitId: habit.id);
    habiRecord.id = await habiRecord.save();
    record = habiRecord;

    final newMotionRecords = await MotionRecord.batchAdd(_lastMotionRecords.map((m) => MotionRecord(
      motionId: m.motionId,
      habitRecordId: record.id,
      sortIndex: m.sortIndex,
    )).toList());
    final newMotionGroupRecords = await MotionGroupRecord.batchAdd(_lastMotionGroupRecords.map((m) => MotionGroupRecord(
      motionRecordId: newMotionRecords[_lastMotionRecords.indexWhere((c) => c.id == m.motionRecordId)].id,
      lastContent: m.content,
      content: m.content.map((c) => MotionContent(category: c.category)).toList(),
    )).toList());

    await _updateMotionRecords(newMotionRecords);
    await _updateMotionGroupRecords(newMotionGroupRecords);
  }

  _updateTo() {
    _timer?.cancel();
    _timer = Timer(Duration(microseconds: 500), () async {
      if (_lock) {
        Future.delayed(Duration(microseconds: 500), () => _updateTo());
      } else {
        _lock = true;
        for (var i = 0; i < motionRecords.length; i++) {
          motionRecords[i].sortIndex = i;
        }
        await MotionRecord.batchUpdate(motionRecords);
        await MotionGroupRecord.batchUpdate(motionGroupRecords);
        _lock = false;
      }
    });
  }

  _updateMotionRecords(List<MotionRecord> items) async {
    final newMotions = await NativeMethod.getMotionsByIds(items.map((e) => e.motionId).toList());
    for (var motion in newMotions) {
      if (motions.indexWhere((m) => m.id == motion.id) == -1) {
        motions.add(motion);
      }
    }
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
