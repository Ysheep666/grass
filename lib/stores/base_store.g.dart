// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BaseStore on _BaseStore, Store {
  final _$routeObserverAtom = Atom(name: '_BaseStore.routeObserver');

  @override
  RouteObserver<ModalRoute<dynamic>> get routeObserver {
    _$routeObserverAtom.context.enforceReadPolicy(_$routeObserverAtom);
    _$routeObserverAtom.reportObserved();
    return super.routeObserver;
  }

  @override
  set routeObserver(RouteObserver<ModalRoute<dynamic>> value) {
    _$routeObserverAtom.context.conditionallyRunInAction(() {
      super.routeObserver = value;
      _$routeObserverAtom.reportChanged();
    }, _$routeObserverAtom, name: '${_$routeObserverAtom.name}_set');
  }

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
  Future<void> setDarkMode(ThemeMode value) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(value));
  }

  @override
  String toString() {
    final string =
        'routeObserver: ${routeObserver.toString()},useDarkMode: ${useDarkMode.toString()}';
    return '{$string}';
  }
}
