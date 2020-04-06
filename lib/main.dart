import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/layouts/container.dart';
import 'package:grass/stores/base_store.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/preferences_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider<PreferencesService>(
        create: (_) => PreferencesService(),
      ),
      ProxyProvider<PreferencesService, BaseStore>(
        update: (_, preferencesService, __) => BaseStore(preferencesService),
      ),
      Provider<HabitStore>(
        create: (_) => HabitStore(),
      ),
      Provider<HabitDetailStore>(
        create: (_) => HabitDetailStore(),
      ),
    ],
    child: Consumer<BaseStore>(
      builder: (_, store, __) => Observer(
        builder: (_) => OKToast(
          backgroundColor: Colors.black.withOpacity(0.72),
          textPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          position: ToastPosition.center,
          child: MaterialApp(
            title: 'Grass',
            themeMode: store.useDarkMode,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('zh', 'CH'),
            ],
            home: ContainerLayout(),
          ),
        ),
      ),
    ),
  );
}

void main() async {
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  runApp(MyApp());
}
