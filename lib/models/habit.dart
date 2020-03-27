import 'package:grass/utils/constant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habit.g.dart';

enum HabitRepeatStatusType {
  day,
  week,
  custom,
}

@JsonSerializable()
class Habit {
  int id;
  String name;
  String remarks;
  HabitRepeatStatusType repeatStatusType;
  List<int> repeatStatusValues;
  DateTime startDate;
  DateTime alertTime;

  Habit({
    this.id,
    this.name = '',
    this.remarks = '',
    this.repeatStatusType = HabitRepeatStatusType.day,
    this.repeatStatusValues,
    this.startDate,
    this.alertTime,
  }) {
    if (this.repeatStatusValues == null) {
      this.repeatStatusValues = Constant.weekDays.asMap().keys.toList();
    }

    if (this.startDate == null) {
      this.startDate = DateTime.now();
    }
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
  Map<String, dynamic> toJson() => _$HabitToJson(this);
}