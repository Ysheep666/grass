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
  static final fieldLastContent = 'lastContent';
  static final fieldContent = 'content';
  static final fieldIsDone = 'isDone';
  static final fieldCreatedDate = 'createdDate';
  static final fieldUpdatedDate = 'updatedDate';

  int motionRecordId;
  @JsonKey(fromJson: valuesFromJson, toJson: valuesToJson)
  List<MotionContent> lastContent;
  @JsonKey(fromJson: valuesFromJson, toJson: valuesToJson)
  List<MotionContent> content;
  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool isDone;
  DateTime createdDate;
  @JsonKey(fromJson: dateTimeFromEpochUs, toJson: dateTimeToEpochUs)
  DateTime updatedDate;

  MotionGroupRecord({
    int id,
    this.lastContent,
    this.content,
    this.motionRecordId,
    this.isDone = false,
  }) : super(id) {
    this.lastContent ??= [];
    this.content ??= [];
    this.createdDate ??= DateTime.now();
    this.updatedDate ??= DateTime.now();
  }

  @override
  bool operator == (Object other) => identical(this, other) ||
    other is MotionGroupRecord &&
    runtimeType == other.runtimeType &&
    id == other.id &&
    updatedDate == other.updatedDate;

  @override
  int get hashCode => id.hashCode;

  bool get isEffective => content.indexWhere((c) => c.value == null || c.value == 0.0) == -1;

  @override
  getTableName() {
    return tableName;
  }

  @override
  Future<void> preSave() async {
    this.updatedDate = DateTime.now();
  }

  MotionGroupRecord copyAndCreated({bool isCreated = false, bool isUpdated = true}) {
    final record = MotionGroupRecord.fromJson(toJson());
    if (isCreated) {
      record.createdDate = DateTime.now();
    }
    if (isCreated || isUpdated) {
      record.updatedDate = DateTime.now();
    }
    return record;
  }

  factory MotionGroupRecord.fromJson(Map<String, dynamic> json) => _$MotionGroupRecordFromJson(json);
  Map<String, dynamic> toJson() => _$MotionGroupRecordToJson(this);

  static Future<List<MotionGroupRecord>> getItemsByMotionRecordIds(List<int> motionRecordIds) async {
    if (motionRecordIds.isEmpty) {
      return [];
    }
    final db = await DbHelper.instance.getDb();
    List<Map> results = await db.query(
      tableName,
      where: '$fieldMotionRecordId IN (${motionRecordIds.join(', ')})',
    );
    return results.map((result) => MotionGroupRecord.fromJson(result)).toList();
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

  static Future<List<MotionGroupRecord>> batchUpdate(List<MotionGroupRecord> motionGroupRecords) async {
    final db = await DbHelper.instance.getDb();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var motionGroupRecord in motionGroupRecords) {
        final json = motionGroupRecord.toJson();
        batch.update(tableName, json, where: 'id = ?', whereArgs: [json['id']]);
      }
      await batch.commit();
    });
    return motionGroupRecords;
  }

  static Future<int> batchDelete(List<MotionGroupRecord> motionGroupRecords) async {
    final motionGroupRecordIds = motionGroupRecords.map((f) => f.id).toList();
    final db = await DbHelper.instance.getDb();
    return await db.delete(tableName, where: '$fieldId IN (${motionGroupRecordIds.join(', ')})');
  }
}