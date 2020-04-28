import 'package:grass/utils/db.dart';
import 'package:json_annotation/json_annotation.dart';

part 'motion_record.g.dart';

@JsonSerializable()
class MotionRecord extends BaseModel {
  static final tableName = 'motion_records';
  static final fieldId = 'id';
  static final fieldMotionId = 'motionId';
  static final fieldHabitRecordId = 'habitRecordId';
  static final fieldSortIndex = 'sortIndex';

  int motionId;
  int habitRecordId;
  int sortIndex;

  MotionRecord({
    int id,
    this.motionId,
    this.habitRecordId,
    this.sortIndex = 0,
  }) : super(id);

  @override
  getTableName() {
    return tableName;
  }

  factory MotionRecord.fromJson(Map<String, dynamic> json) => _$MotionRecordFromJson(json);
  Map<String, dynamic> toJson() => _$MotionRecordToJson(this);

  static Future<List<MotionRecord>> getItemsByHabitRecordId(int habitRecordId) async {
    final db = await DbHelper.instance.getDb();
    List<Map> results = await db.query(
      tableName,
      where: '$fieldHabitRecordId = ?',
      whereArgs: [habitRecordId],
    );
    return results.map((result) => MotionRecord.fromJson(result)).toList();
  }

  static Future<List<MotionRecord>> batchAdd(List<MotionRecord> motionRecords) async {
    final db = await DbHelper.instance.getDb();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var motionRecord in motionRecords) {
        batch.insert(tableName, motionRecord.toJson());
      }
      final ids = await batch.commit();
      for (var i = 0; i < ids.length; i++) {
        motionRecords[i].id = ids[i];
      }
    });
    return motionRecords;
  }

  static Future<List<MotionRecord>> batchUpdate(List<MotionRecord> motionRecords) async {
    final db = await DbHelper.instance.getDb();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var motionRecord in motionRecords) {
        final json = motionRecord.toJson();
        batch.update(tableName, json, where: 'id = ?', whereArgs: [json['id']]);
      }
      await batch.commit();
    });
    return motionRecords;
  }
}