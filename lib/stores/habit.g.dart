// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HabitStore on _BaseStore, Store {
  final _$formAtom = Atom(name: '_BaseStore.form');

  @override
  Habit get form {
    _$formAtom.context.enforceReadPolicy(_$formAtom);
    _$formAtom.reportObserved();
    return super.form;
  }

  @override
  set form(Habit value) {
    _$formAtom.context.conditionallyRunInAction(() {
      super.form = value;
      _$formAtom.reportChanged();
    }, _$formAtom, name: '${_$formAtom.name}_set');
  }

  final _$setFormAsyncAction = AsyncAction('setForm');

  @override
  Future<void> setForm({@required Habit value}) {
    return _$setFormAsyncAction.run(() => super.setForm(value: value));
  }

  @override
  String toString() {
    final string = 'form: ${form.toString()}';
    return '{$string}';
  }
}
