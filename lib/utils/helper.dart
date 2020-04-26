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

// 时间转格式化字符串，单位秒
String valueFromDuration(int value) {
  final duration = Duration(seconds: value);

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  List<String> parts = [];
  if (duration.inHours > 0) {
    parts.add(duration.inHours.toString());
  }
  final inMinutes = duration.inMinutes.remainder(Duration.minutesPerHour);
  if (parts.length > 0 || inMinutes > 0) {
    parts.add(twoDigits(inMinutes));
  }
  final inSeconds = duration.inSeconds.remainder(Duration.secondsPerMinute);
  if (parts.length > 0 || inSeconds > 0) {
    parts.add(twoDigits(inSeconds));
  }
  return parts.join(':');
}
// 格式化字符转时间秒数
int valueToDuration(String value) {
  final times = List.filled(3, 0);
  final parts = value.split(':').reversed.map((f) => int.parse(f)).toList();
  for (var i = 0; i < parts.length; i++) {
    times[i] = parts[i];
  }
  final duration = Duration(hours: times[2], minutes: times[1], seconds: times[0]);
  return duration.inSeconds;
}

/// 获取 bottom sheet 高度，去除掉 aafearea top, 将剩下的分成 16份，value 表示去多少份
double getModalBottomSheetHeight(int value) {
  final data = MediaQueryData.fromWindow(window);
  return (data.size.height - data.padding.top) * value / 16;
}
