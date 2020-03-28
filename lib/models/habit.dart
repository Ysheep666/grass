import 'package:grass/utils/constant.dart';
import 'package:grass/utils/db_helper.dart';
import 'package:grass/utils/helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habit.g.dart';

enum HabitRepeatStatusType {
  day,
  week,
  custom,
}

@JsonSerializable()
class Habit {
  static final tableName = "habits";
  static final fieldId = "id";
  static final fieldName = "name";
  static final fieldRemarks = "remarks";
  static final fieldRepeatStatusType = "repeatStatusType";
  static final fieldRepeatSxtatusValues = "repeatStatusValues";
  static final fieldStartDate = "startDate";
  static final fieldAlertTime = "alertTime";
  static final fieldIsArchived = "isArchived";
  static final fieldCreatedDate = "createdDate";
  static final fieldUpdatedDate = "updatedDate";

  int id;
  String name;
  String remarks;
  HabitRepeatStatusType repeatStatusType;
  @JsonKey(fromJson: _valuesFromString, toJson: _valuesToString)
  List<int> repeatStatusValues;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime startDate;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime alertTime;
  bool isArchived;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime createdDate;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime updatedDate;

  Habit({
    this.id,
    this.name = '',
    this.remarks = '',
    this.repeatStatusType = HabitRepeatStatusType.day,
    this.repeatStatusValues,
    this.startDate,
    this.alertTime,
    this.isArchived = false,
    this.createdDate,
    this.updatedDate,
  }) {
    this.repeatStatusValues ??= Constant.weekDays.asMap().keys.toList();
    this.startDate ??= DateTime.now();
    this.createdDate ??= DateTime.now();
    this.updatedDate ??= DateTime.now();
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
  Map<String, dynamic> toJson() => _$HabitToJson(this);

  static List<int> _valuesFromString(String text) => text == null ? [] : text.split('|').map((a) => int.parse(a)).toList();
  static String _valuesToString(List<int> values) => values?.join('|');

  static Future<Habit> save(Habit habit) async {
    final db = await DbHelper.instance.getDb();
    if (habit.id == null) {
      habit.id = await db.insert(tableName, habit.toJson());
    } else {
      await db.update(
        tableName,
        habit.toJson(),
        where: '$fieldId = ?',
        whereArgs: [habit.id]
      );
    }
    return habit;
  }

  static Future<List<Habit>> getHabits() async {
    final db = await DbHelper.instance.getDb();
    List<Map> resets = await db.query(tableName);
    return resets.map((reset) => Habit.fromJson(reset)).toList();
  }
}