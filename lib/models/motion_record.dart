import 'package:grass/utils/db.dart';
import 'package:json_annotation/json_annotation.dart';

part 'motion_record.g.dart';

@JsonSerializable()
class MotionRecord extends BaseModel {
  static final tableName = 'motion_records';
  static final fieldId = 'id';
  static final fieldMotionId = 'motionId';
  static final fieldHabitRecordId = 'habitRecordId';

  int motionId;
  int habitRecordId;

  MotionRecord({
    int id,
    this.motionId,
    this.habitRecordId,
  }) : super(id);

  factory MotionRecord.fromJson(Map<String, dynamic> json) => _$MotionRecordFromJson(json);
  Map<String, dynamic> toJson() => _$MotionRecordToJson(this);

  static Future<MotionRecord> save(MotionRecord value) async {
    final reset = await DbHelper.instance.save(value.toJson(), tableName: tableName);
    return MotionRecord.fromJson(reset);
  }

  static Future<int> delete(int id) async {
    return await DbHelper.instance.delete(id, tableName: tableName);
  }
}