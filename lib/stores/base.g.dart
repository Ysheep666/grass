// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BaseStore on _BaseStore, Store {
  final _$useDarkModeAtom = Atom(name: '_BaseStore.useDarkMode');

  @override
  ThemeMode get useDarkMode {
    _$useDarkModeAtom.context.enforceReadPolicy(_$useDarkModeAtom);
    _$useDarkModeAtom.reportObserved();
    return super.useDarkMode;
  }

  @override
  set useDarkMode(ThemeMode value) {
    _$useDarkModeAtom.context.conditionallyRunInAction(() {
      super.useDarkMode = value;
      _$useDarkModeAtom.reportChanged();
    }, _$useDarkModeAtom, name: '${_$useDarkModeAtom.name}_set');
  }

  final _$setDarkModeAsyncAction = AsyncAction('setDarkMode');

  @override
  Future<void> setDarkMode({@required ThemeMode value}) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(value: value));
  }

  @override
  String toString() {
    final string = 'useDarkMode: ${useDarkMode.toString()}';
    return '{$string}';
  }
}
