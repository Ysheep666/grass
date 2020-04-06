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
  static final fieldCreatedDate = 'createdDate';
  static final fieldUpdatedDate = 'updatedDate';

  int motionRecordId;
  @JsonKey(fromJson: _valuesFromJson, toJson: _valuesToJson)
  List<MotionContent> content;
  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool isDone;
  DateTime createdDate;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime updatedDate;

  MotionGroupRecord({
    int id,
    this.content,
    this.motionRecordId,
    this.isDone = false,
  }) : super(id) {
    this.content ??= [];
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

  static Future<List<MotionGroupRecord>> getItemsByMotionRecordIds(List<int> motionRecordIds) async {
    if (motionRecordIds.isEmpty) {
      return [];
    }
    final db = await DbHelper.instance.getDb();
    List<Map> resets = await db.query(
      tableName,
      where: '$fieldMotionRecordId IN (?)',
      whereArgs: [motionRecordIds.join(',')],
    );
    return resets.map((reset) => MotionGroupRecord.fromJson(reset)).toList();
  }
}