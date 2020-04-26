// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitRecord _$HabitRecordFromJson(Map<String, dynamic> json) {
  return HabitRecord(
    id: json['id'] as int,
    habitId: json['habitId'] as int,
    isDone: boolFromInt(json['isDone'] as int),
    isArchived: boolFromInt(json['isArchived'] as int),
    createdDate: dateTimeFromEpochUs(json['createdDate'] as int),
    updatedDate: dateTimeFromEpochUs(json['updatedDate'] as int),
  );
}

Map<String, dynamic> _$HabitRecordToJson(HabitRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'habitId': instance.habitId,
      'isDone': boolToInt(instance.isDone),
      'isArchived': boolToInt(instance.isArchived),
      'createdDate': dateTimeToEpochUs(instance.createdDate),
      'updatedDate': dateTimeToEpochUs(instance.updatedDate),
    };
