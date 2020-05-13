import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/layouts/container.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/stores/base_store.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/notifications.dart';
import 'package:grass/utils/preferences_service.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    GsNotifications.instance.onSelectNotification = (String payload) async {
      print('select nottification: $payload');
    };
    WidgetsBinding.instance.addObserver(this);
    _resetNotifications();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resetNotifications();
    }
  }
  
  // 设置提醒消息，只设置 30 天以内的，1 小时内最多触发一次
  _resetNotifications() {
    Future.delayed(Duration.zero, () async {
      final preferencesService = PreferencesService();
      await preferencesService.loaded;
      final notificationUpdated = preferencesService.sharedPreferences.getInt('custom@notificationUpdated');
      if (
        notificationUpdated == null  || 
        DateTime.fromMicrosecondsSinceEpoch(notificationUpdated).difference(DateTime.now()).inHours > 1
      ) {
        print('update notifications');
        GsNotifications.instance.flutterLocalNotificationsPlugin.cancelAll();
        final habits = await Habit.getItems();
        for (var habit in habits) {
          for (var alertTime in habit.inMonthAlertTimes) {
            await GsNotifications.instance.flutterLocalNotificationsPlugin.schedule(
              (alertTime.millisecondsSinceEpoch / 1000).floor(), 
              habit.name, 
              '您今天还有锻炼任务未完成，努力坚持一下吧！❤️', 
              alertTime, 
              NotificationDetails(
                AndroidNotificationDetails('', '', ''), 
                IOSNotificationDetails(),
              ),
            );
          }
        }
        preferencesService.sharedPreferences.setInt('custom@notificationUpdated', DateTime.now().millisecondsSinceEpoch);
      }
    });
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
        builder: (_) => CupertinoApp(
          title: 'Grass',
          theme: CupertinoThemeData(
            brightness: store.useDarkMode == ThemeMode.light ? Brightness.light : Brightness.dark,
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('zh', 'CH'),
          ],
          navigatorObservers: [store.routeObserver],
          home: ContainerLayout(),
        ),
      ),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  await GsNotifications.instance.initialize();
  runApp(MyApp());
}
