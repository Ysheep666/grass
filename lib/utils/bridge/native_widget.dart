
import 'package:flutter/services.dart';

enum ToastPosition {
  top,
  center,
  bottom,
}

const _ToastPositionEnumMap = {
  ToastPosition.top: 0,
  ToastPosition.center: 1,
  ToastPosition.bottom: 2,
};

enum AlertPreferredStyle {
  actionSheet,
  alert,
}

const _AlertPreferredStyleEnumMap = {
  AlertPreferredStyle.actionSheet: 0,
  AlertPreferredStyle.alert: 1,
};

enum AlertActionStyle {
  base,
  cancel,
  destructive,
}

const _AlertActionStyleEnumMap = {
  AlertActionStyle.base: 0,
  AlertActionStyle.cancel: 1,
  AlertActionStyle.destructive: 2,
};

class AlertAction {
  final String value;
  final String title;
  final AlertActionStyle style;
  AlertAction({this.value, this.title, this.style = AlertActionStyle.base});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'value': value,
    'title': title,
    'style': _AlertActionStyleEnumMap[style],
  };
}

class NativeWidget {
  static const _channel = const MethodChannel('com.penta.Grass/native_widget');

  static Future<void> toast(message, {
    int duration = 1,
    ToastPosition position = ToastPosition.center,
  }) async {
    await _channel.invokeMethod('toast', {
      'message': message,
      'duration': duration,
      'position': _ToastPositionEnumMap[position],
    });
  }

  static const String DEFAULT_POSITIVE_BUTTON_TEXT = '确定';
  static const String DEFAULT_NEGATIVE_BUTTON_TEXT = '取消';

  static Future<String> alert({
    String title,
    String message,
    AlertPreferredStyle preferredStyle = AlertPreferredStyle.alert,
    List<AlertAction> actions = const [],
  }) async {
    final result = await _channel.invokeMethod('alert', {
      'title': title,
      'message': message,
      'preferredStyle': _AlertPreferredStyleEnumMap[preferredStyle],
      'actions': actions.map((f) => f.toJson()).toList(),
    });
    return result as String;
  }

  static Future<List<int>> motionPicker() async {
    final result = await _channel.invokeMethod('motionPicker', {});
    return result is List ? result.map((e) => e as int).toList() : [];
  }
}
