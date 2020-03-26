import 'package:grass/utils/constant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habit.g.dart';

@JsonSerializable()
class Habit {
  int id;
  String name;
  String remarks;
  int repeatStatusType;
  List<int> repeatStatusValues;

  Habit({
    this.id,
    this.name = '',
    this.remarks = '',
    this.repeatStatusType = 0,
    this.repeatStatusValues,
  }) {
    if (this.repeatStatusValues == null) {
      this.repeatStatusValues = Constant.weekDays.asMap().keys.toList();
    }
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
  Map<String, dynamic> toJson() => _$HabitToJson(this);
}