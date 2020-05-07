import 'package:grass/utils/db.dart';
import 'package:grass/utils/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'motion_record.dart';

part 'habit_record.g.dart';

@JsonSerializable()
class HabitRecord extends BaseModel {
  static final tableName = 'habit_records';
  static final fieldId = 'id';
  static final fieldHabitId = 'habitId';
  static final fieldIsDone = 'isDone';
  static final fieldIsArchived = 'isArchived';
  static final fieldCreatedDate = 'createdDate';
  static final fieldUpdatedDate = 'updatedDate';

  int habitId;
  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool isDone;
  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool isArchived;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime createdDate;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime updatedDate;

  @JsonKey(ignore: true)
  List<MotionRecord> motions;

  HabitRecord({
    int id,
    this.habitId,
    this.isDone = false,
    this.isArchived = false,
    this.createdDate,
    this.updatedDate,
  }) : super(id) {
    this.createdDate ??= DateTime.now();
    this.updatedDate ??= DateTime.now();
  }

  @override
  getTableName() {
    return tableName;
  }

  @override
  Future<void> preSave() async {
    this.updatedDate = DateTime.now();
  }

  factory HabitRecord.fromJson(Map<String, dynamic> json) => _$HabitRecordFromJson(json);
  Map<String, dynamic> toJson() => _$HabitRecordToJson(this);

  static Future<List<HabitRecord>> getLastByHabitId(int habitId) async {
    final db = await DbHelper.instance.getDb();
    List<Map> results = await db.query(
      tableName,
      where: '$fieldHabitId = ? AND isArchived = 0',
      whereArgs: [habitId],
      orderBy: '$fieldId DESC',
      limit: 2,
    );
    return results.map((r) => HabitRecord.fromJson(r)).toList();
  }
}
