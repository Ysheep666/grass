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

  final _$itemsAtom = Atom(name: '_HabitStore.items');

  @override
  List<Habit> get items {
    _$itemsAtom.context.enforceReadPolicy(_$itemsAtom);
    _$itemsAtom.reportObserved();
    return super.items;
  }

  @override
  set items(List<Habit> value) {
    _$itemsAtom.context.conditionallyRunInAction(() {
      super.items = value;
      _$itemsAtom.reportChanged();
    }, _$itemsAtom, name: '${_$itemsAtom.name}_set');
  }

  final _$saveAsyncAction = AsyncAction('save');

  @override
  Future<void> save(Habit value) {
    return _$saveAsyncAction.run(() => super.save(value));
  }

  final _$didLoadAsyncAction = AsyncAction('didLoad');

  @override
  Future<void> didLoad() {
    return _$didLoadAsyncAction.run(() => super.didLoad());
  }

  @override
  String toString() {
    final string =
        'isLoaded: ${isLoaded.toString()},items: ${items.toString()}';
    return '{$string}';
  }
}
