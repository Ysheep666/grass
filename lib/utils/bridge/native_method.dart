import 'package:flutter/services.dart';

enum ImpactFeedbackStyle {
  light,
  medium,
  heavy,
  soft,
  rigid,
}

enum NotificationFeedbackType {
  success,
  warning,
  error,
}

const _notificationFeedbackTypeEnumMap = {
  NotificationFeedbackType.success: 0,
  NotificationFeedbackType.warning: 1,
  NotificationFeedbackType.error: 2,
};

class NativeMethod {
  static const _nativeMethod = const MethodChannel('com.penta.Grass/native_method');

  static Future<void> impactFeedback(ImpactFeedbackStyle type) async {
    switch (type) {
      case ImpactFeedbackStyle.light:
        await HapticFeedback.lightImpact();
        break;
      case ImpactFeedbackStyle.medium:
        await HapticFeedback.mediumImpact();
        break;
      case ImpactFeedbackStyle.heavy:
        await HapticFeedback.heavyImpact();
        break;
      case ImpactFeedbackStyle.soft:
        await HapticFeedback.selectionClick();
        break;
      default:
        break;
    }
  }

  static Future<void> notificationFeedback(NotificationFeedbackType type) async {
    await _nativeMethod.invokeMethod('notificationFeedback', _notificationFeedbackTypeEnumMap[type]);
  }
}
