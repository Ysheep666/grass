import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int calculateDifference(DateTime a, DateTime b) {
  return DateTime(a.year, a.month, a.day).difference(DateTime(b.year, b.month, b.day)).inDays;
}

String dateTimeFromNow(DateTime dateTime, [String pattern])  {
  final diffDay = calculateDifference(dateTime, DateTime.now());
  if (diffDay == 0) {
    return '今天';
  }
  if (diffDay == -1) {
    return '昨天';
  }
  if (diffDay == 1) {
    return '明天';
  }
  return DateFormat(pattern ?? 'yyyy年MMMMdd日', 'zh_CH').format(dateTime);
}

/// 时间戳转日期
DateTime dateTimeFromEpochUs(int us) =>
      us == null ? null : DateTime.fromMicrosecondsSinceEpoch(us);

/// 日期转时间戳
int dateTimeToEpochUs(DateTime dateTime) => dateTime?.microsecondsSinceEpoch;

/// 数字转布尔
bool boolFromInt(int i) => i != 0;

/// 布尔转数字
int boolToInt(bool b) => b ? 1 : 0;

double getModalBottomSheetHeight(int value) {
  final data = MediaQueryData.fromWindow(window);
  return (data.size.height - data.padding.top) * value / 16;
}

class AlertDialogActionModel {
  final Widget content;
  final VoidCallback onPressed;
  AlertDialogActionModel({this.content, this.onPressed});
}
