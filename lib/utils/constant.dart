import 'package:grass/utils/mitt.dart';

class Constant {
  static final emitter = Mitt();
  static final weekDays = '星期一_星期二_星期三_星期四_星期五_星期六_星期日'.split('_');
  static final weekDaysShort = '周一_周二_周三_周四_周五_周六_周日'.split('_');

  static final double weightSingleValue = 1.25; // kg or lbs
  static final double distanceSingleValue = 0.1; // km or ft
  static final double numberSingleValue = 1; // 次
  static final double durationSingleValue = 30; // 秒
}
