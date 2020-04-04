// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HabitStore on _HabitStore, Store {
  final _$isLoadedAtom = Atom(name: '_HabitStore.isLoaded');

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

  final _$selectedDateAtom = Atom(name: '_HabitStore.selectedDate');

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.context.enforceReadPolicy(_$selectedDateAtom);
    _$selectedDateAtom.reportObserved();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.context.conditionallyRunInAction(() {
      super.selectedDate = value;
      _$selectedDateAtom.reportChanged();
    }, _$selectedDateAtom, name: '${_$selectedDateAtom.name}_set');
  }

  final _$itemsAtom = Atom(name: '_HabitStore.items');

  @override
  ObservableList<Habit> get items {
    _$itemsAtom.context.enforceReadPolicy(_$itemsAtom);
    _$itemsAtom.reportObserved();
    return super.items;
  }

  @override
  set items(ObservableList<Habit> value) {
    _$itemsAtom.context.conditionallyRunInAction(() {
      super.items = value;
      _$itemsAtom.reportChanged();
    }, _$itemsAtom, name: '${_$itemsAtom.name}_set');
  }

  final _$didLoadAsyncAction = AsyncAction('didLoad');

  @override
  Future<void> didLoad() {
    return _$didLoadAsyncAction.run(() => super.didLoad());
  }

  final _$saveAsyncAction = AsyncAction('save');

  @override
  Future<void> save(Habit value) {
    return _$saveAsyncAction.run(() => super.save(value));
  }

  final _$removeAsyncAction = AsyncAction('remove');

  @override
  Future<void> remove(Habit value) {
    return _$removeAsyncAction.run(() => super.remove(value));
  }

  final _$_HabitStoreActionController = ActionController(name: '_HabitStore');

  @override
  dynamic setSelectedDate(DateTime value) {
    final _$actionInfo = _$_HabitStoreActionController.startAction();
    try {
      return super.setSelectedDate(value);
    } finally {
      _$_HabitStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'isLoaded: ${isLoaded.toString()},selectedDate: ${selectedDate.toString()},items: ${items.toString()}';
    return '{$string}';
  }
}
