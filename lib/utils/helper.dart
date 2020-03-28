int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
}

/// 时间戳转日期
DateTime dateTimeFromEpochUs(int us) =>
      us == null ? null : DateTime.fromMicrosecondsSinceEpoch(us);

/// 日期转时间戳
int dateTimeToEpochUs(DateTime dateTime) => dateTime?.microsecondsSinceEpoch;
