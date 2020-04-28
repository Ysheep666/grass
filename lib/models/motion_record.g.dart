// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotionRecord _$MotionRecordFromJson(Map<String, dynamic> json) {
  return MotionRecord(
    id: json['id'] as int,
    motionId: json['motionId'] as int,
    habitRecordId: json['habitRecordId'] as int,
    sortIndex: json['sortIndex'] as int,
  );
}

Map<String, dynamic> _$MotionRecordToJson(MotionRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'motionId': instance.motionId,
      'habitRecordId': instance.habitRecordId,
      'sortIndex': instance.sortIndex,
    };
