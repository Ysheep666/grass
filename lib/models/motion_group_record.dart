import 'dart:convert';

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

  static List<MotionContent> _valuesFromJson(String jsonText) {
    final json = jsonText == null ? [] : jsonDecode(jsonText);
    return (json as List)
      ?.map((e) => e == null
          ? null
          : MotionContent.fromJson(e as Map<String, dynamic>))
      ?.toList();
  }

  static String _valuesToJson(List<MotionContent> values) {
    final json = values
      ?.map((e) => e == null
          ? null
          : e.toJson())
      ?.toList();
    return jsonEncode(json);
  }

  static Future<List<MotionGroupRecord>> getItemsByMotionRecordIds(List<int> motionRecordIds) async {
    if (motionRecordIds.isEmpty) {
      return [];
    }
    final db = await DbHelper.instance.getDb();
    List<Map> resets = await db.query(
      tableName,
      where: '$fieldMotionRecordId IN (${motionRecordIds.join(', ')})',
    );
    return resets.map((reset) => MotionGroupRecord.fromJson(reset)).toList();
  }

  static Future<List<MotionGroupRecord>> batchAdd(List<MotionGroupRecord> motionGroupRecords) async {
    final db = await DbHelper.instance.getDb();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var motionGroupRecord in motionGroupRecords) {
        batch.insert(tableName, motionGroupRecord.toJson());
      }
      final ids = await batch.commit();
      for (var i = 0; i < ids.length; i++) {
        motionGroupRecords[i].id = ids[i];
      }
    });
    return motionGroupRecords;
  }
}