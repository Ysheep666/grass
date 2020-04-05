import 'package:grass/utils/db.dart';
import 'package:grass/utils/helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habit_record.g.dart';

@JsonSerializable()
class HabitRecord extends BaseModel {
  static final tableName = "habit_records";
  static final fieldId = "id";
  static final fieldHabitId = "habitId";
  static final fieldIsDone = "isDone";
  static final fieldCreatedDate = "createdDate";
  static final fieldUpdatedDate = "updatedDate";

  int habitId;
  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool isDone;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime createdDate;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime updatedDate;

  HabitRecord({
    int id,
    this.habitId,
    this.isDone = false,
    this.createdDate,
    this.updatedDate,
  }) : super(id) {
    this.createdDate ??= DateTime.now();
    this.updatedDate ??= DateTime.now();
  }

  factory HabitRecord.fromJson(Map<String, dynamic> json) => _$HabitRecordFromJson(json);
  Map<String, dynamic> toJson() => _$HabitRecordToJson(this);

  static Future<HabitRecord> save(HabitRecord value) async {
    final reset = await DbHelper.instance.save(value.toJson(), tableName: tableName);
    return HabitRecord.fromJson(reset);
  }

  static Future<int> delete(int id) async {
    return await DbHelper.instance.delete(id, tableName: tableName);
  }

  static Future<List<HabitRecord>> getItemsByHabitId(int habitId) async {
    final db = await DbHelper.instance.getDb();
    List<Map> resets = await db.query(
      tableName,
      where: '$fieldHabitId = ?',
      whereArgs: [habitId],
    );
    return resets.map((reset) => HabitRecord.fromJson(reset)).toList();
  }
}