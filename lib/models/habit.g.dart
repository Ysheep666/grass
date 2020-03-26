// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) {
  return Habit(
    id: json['id'] as int,
    name: json['name'] as String,
    remarks: json['remarks'] as String,
    repeatStatusType: json['repeatStatusType'] as int,
    repeatStatusValues:
        (json['repeatStatusValues'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'remarks': instance.remarks,
      'repeatStatusType': instance.repeatStatusType,
      'repeatStatusValues': instance.repeatStatusValues,
    };
