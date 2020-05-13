import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class GsNotifications {
  factory GsNotifications() => _getInstance();
  static GsNotifications get instance => _getInstance();
  static GsNotifications _instance;

  static GsNotifications _getInstance() {
    if (_instance == null) {
      _instance = GsNotifications._internal();
    }
    return _instance;
  }

  GsNotifications._internal();

  SelectNotificationCallback onSelectNotification;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initialize() async {    
    final initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
      if (onSelectNotification != null) {
        onSelectNotification(payload);
      }
    });
  }
}