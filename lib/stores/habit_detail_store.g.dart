// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HabitDetailStore on _HabitDetailStore, Store {
  final _$isLoadedAtom = Atom(name: '_HabitDetailStore.isLoaded');

  @override
  bool get isLoaded {
    _$isLoadedAtom.context.enforceReadPolicy(_$isLoadedAtom);
    _$isLoadedAtom.reportObserved();
    return super.isLoaded;
  }

  @override
  set isLoaded(bool value) {
    _$isLoadedAtom.context.conditionallyRunInAction(() {
      super.isLoaded = value;
      _$isLoadedAtom.reportChanged();
    }, _$isLoadedAtom, name: '${_$isLoadedAtom.name}_set');
  }

  final _$habitAtom = Atom(name: '_HabitDetailStore.habit');

  @override
  Habit get habit {
    _$habitAtom.context.enforceReadPolicy(_$habitAtom);
    _$habitAtom.reportObserved();
    return super.habit;
  }

  @override
  set habit(Habit value) {
    _$habitAtom.context.conditionallyRunInAction(() {
      super.habit = value;
      _$habitAtom.reportChanged();
    }, _$habitAtom, name: '${_$habitAtom.name}_set');
  }

  final _$recordAtom = Atom(name: '_HabitDetailStore.record');

  @override
  HabitRecord get record {
    _$recordAtom.context.enforceReadPolicy(_$recordAtom);
    _$recordAtom.reportObserved();
    return super.record;
  }

  @override
  set record(HabitRecord value) {
    _$recordAtom.context.conditionallyRunInAction(() {
      super.record = value;
      _$recordAtom.reportChanged();
    }, _$recordAtom, name: '${_$recordAtom.name}_set');
  }

  final _$motionRecordsAtom = Atom(name: '_HabitDetailStore.motionRecords');

  @override
  ObservableList<MotionRecord> get motionRecords {
    _$motionRecordsAtom.context.enforceReadPolicy(_$motionRecordsAtom);
    _$motionRecordsAtom.reportObserved();
    return super.motionRecords;
  }

  @override
  set motionRecords(ObservableList<MotionRecord> value) {
    _$motionRecordsAtom.context.conditionallyRunInAction(() {
      super.motionRecords = value;
      _$motionRecordsAtom.reportChanged();
    }, _$motionRecordsAtom, name: '${_$motionRecordsAtom.name}_set');
  }

  final _$motionGroupRecordsAtom =
      Atom(name: '_HabitDetailStore.motionGroupRecords');

  @override
  ObservableList<MotionGroupRecord> get motionGroupRecords {
    _$motionGroupRecordsAtom.context
        .enforceReadPolicy(_$motionGroupRecordsAtom);
    _$motionGroupRecordsAtom.reportObserved();
    return super.motionGroupRecords;
  }

  @override
  set motionGroupRecords(ObservableList<MotionGroupRecord> value) {
    _$motionGroupRecordsAtom.context.conditionallyRunInAction(() {
      super.motionGroupRecords = value;
      _$motionGroupRecordsAtom.reportChanged();
    }, _$motionGroupRecordsAtom, name: '${_$motionGroupRecordsAtom.name}_set');
  }

  final _$didLoadAsyncAction = AsyncAction('didLoad');

  @override
  Future<void> didLoad(Habit value) {
    return _$didLoadAsyncAction.run(() => super.didLoad(value));
  }

  @override
  String toString() {
    final string =
        'isLoaded: ${isLoaded.toString()},habit: ${habit.toString()},record: ${record.toString()},motionRecords: ${motionRecords.toString()},motionGroupRecords: ${motionGroupRecords.toString()}';
    return '{$string}';
  }
}
