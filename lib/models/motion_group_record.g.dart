// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion_group_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotionGroupRecord _$MotionGroupRecordFromJson(Map<String, dynamic> json) {
  return MotionGroupRecord(
    id: json['id'] as int,
    content: MotionGroupRecord._valuesFromJson(json['content']),
    motionRecordId: json['motionRecordId'] as int,
    isDone: boolFromInt(json['isDone'] as int),
  )
    ..createdDate = json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String)
    ..updatedDate = dateTimeFromEpochUs(json['updatedDate'] as int);
}

Map<String, dynamic> _$MotionGroupRecordToJson(MotionGroupRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'motionRecordId': instance.motionRecordId,
      'content': MotionGroupRecord._valuesToJson(instance.content),
      'isDone': boolToInt(instance.isDone),
      'createdDate': instance.createdDate?.toIso8601String(),
      'updatedDate': dateTimeToEpochUs(instance.updatedDate),
    };
