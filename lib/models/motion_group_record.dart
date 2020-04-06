import 'package:grass/utils/db.dart';
import 'package:grass/utils/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'motion_content.dart';

part 'motion_group_record.g.dart';

@JsonSerializable()
class MotionGroupRecord extends BaseModel {
  static final tableName = 'motion_group_records';
  static final fieldId = 'id';
  static final fieldMotionRecordId = 'motionRecordId';
  static final fieldContent = 'content';
  static final fieldIsDone = 'isDone';

  int motionRecordId;
  @JsonKey(fromJson: _valuesFromJson, toJson: _valuesToJson)
  List<MotionContent> content;
  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool isDone;

  MotionGroupRecord({
    int id,
    this.content,
    this.motionRecordId,
    this.isDone = false,
  }) : super(id) {
    this.content ??= [];
  }

  factory MotionGroupRecord.fromJson(Map<String, dynamic> json) => _$MotionGroupRecordFromJson(json);
  Map<String, dynamic> toJson() => _$MotionGroupRecordToJson(this);

  static List<MotionContent> _valuesFromJson(dynamic json) => (json as List)
      ?.map((e) => e == null
          ? null
          : MotionContent.fromJson(e as Map<String, dynamic>))
      ?.toList();
  static List<dynamic> _valuesToJson(List<MotionContent> values) => values
      ?.map((e) => e == null
          ? null
          : e.toJson())
      ?.toList();

  static Future<MotionGroupRecord> save(MotionGroupRecord value) async {
    final reset = await DbHelper.instance.save(value.toJson(), tableName: tableName);
    return MotionGroupRecord.fromJson(reset);
  }

  static Future<int> delete(int id) async {
    return await DbHelper.instance.delete(id, tableName: tableName);
  }
}