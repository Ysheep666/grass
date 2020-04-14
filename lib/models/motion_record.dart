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

  @override
  getTableName() {
    return tableName;
  }

  factory MotionRecord.fromJson(Map<String, dynamic> json) => _$MotionRecordFromJson(json);
  Map<String, dynamic> toJson() => _$MotionRecordToJson(this);

  static Future<List<MotionRecord>> getItemsByHabitRecordId(int habitRecordId) async {
    final db = await DbHelper.instance.getDb();
    List<Map> resets = await db.query(
      tableName,
      where: '$fieldHabitRecordId = ?',
      whereArgs: [habitRecordId],
    );
    return resets.map((reset) => MotionRecord.fromJson(reset)).toList();
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
}