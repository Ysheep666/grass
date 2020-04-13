
import 'package:flutter/services.dart';
import 'package:flutter_native_dialog/flutter_native_dialog.dart';

enum ToastPosition {
  top,
  center,
  bottom,
}

const _toastPositionEnumMap = {
  ToastPosition.top: 0,
  ToastPosition.center: 1,
  ToastPosition.bottom: 2,
};

class NativeWidget {
  static const _channel = const MethodChannel('com.penta.Grass/native_widget');

  static const String DEFAULT_POSITIVE_BUTTON_TEXT = '确定';
  static const String DEFAULT_NEGATIVE_BUTTON_TEXT = '取消';

  static Future<bool> showAlertDialog({
    String title,
    String message,
    String positiveButtonText,
  }) async {
    return await FlutterNativeDialog.showAlertDialog(
      title: title,
      message: message,
      positiveButtonText: positiveButtonText,
    );
  }

  static Future<bool> showConfirmDialog({
    String title,
    String message,
    String positiveButtonText = DEFAULT_POSITIVE_BUTTON_TEXT,
    String negativeButtonText = DEFAULT_NEGATIVE_BUTTON_TEXT,
    bool destructive = true,
  }) async {
    return await FlutterNativeDialog.showConfirmDialog(
      title: title,
      message: message,
      positiveButtonText: positiveButtonText,
      negativeButtonText: negativeButtonText,
      destructive: destructive,
    );
  }

  static Future<void> toast(message, {
    int duration = 2,
    ToastPosition position = ToastPosition.center,
  }) async {
    await _channel.invokeMethod('toast', {
      'message': message,
      'duration': duration,
      'position': _toastPositionEnumMap[position],
    });
  }

  static Future<List<int>> motionPicker() async {
    final reset = await _channel.invokeMethod('motionPicker', {});
    return reset is List ? reset.map((e) => e as int).toList() : [];
  }
}
