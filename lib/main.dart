import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/layouts/container.dart';
import 'package:grass/stores/base.dart';
import 'package:grass/utils/preferences_service.dart';
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
    ],
    child: Consumer<BaseStore>(
      builder: (_, store, __) => Observer(
        builder: (_) => MaterialApp(
          title: 'Grass',
          theme: ThemeData(
            splashColor: Colors.transparent,
          ),
          themeMode: store.useDarkMode,
          routes: {
            '/': (context) => ContainerLayout(),
          },
        ),
      ),
    ),
  );
}

void main() async {
  runApp(MyApp());
}
