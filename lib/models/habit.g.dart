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
    repeatStatusType: _$enumDecodeNullable(
        _$HabitRepeatStatusTypeEnumMap, json['repeatStatusType']),
    repeatStatusValues:
        Habit._valuesFromString(json['repeatStatusValues'] as String),
    startDate: dateTimeFromEpochUs(json['startDate'] as int),
    alertTime: dateTimeFromEpochUs(json['alertTime'] as int),
    isArchived: json['isArchived'] as bool,
    createdDate: dateTimeFromEpochUs(json['createdDate'] as int),
    updatedDate: dateTimeFromEpochUs(json['updatedDate'] as int),
  );
}

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'remarks': instance.remarks,
      'repeatStatusType':
          _$HabitRepeatStatusTypeEnumMap[instance.repeatStatusType],
      'repeatStatusValues': Habit._valuesToString(instance.repeatStatusValues),
      'startDate': dateTimeToEpochUs(instance.startDate),
      'alertTime': dateTimeToEpochUs(instance.alertTime),
      'isArchived': instance.isArchived,
      'createdDate': dateTimeToEpochUs(instance.createdDate),
      'updatedDate': dateTimeToEpochUs(instance.updatedDate),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$HabitRepeatStatusTypeEnumMap = {
  HabitRepeatStatusType.day: 'day',
  HabitRepeatStatusType.week: 'week',
  HabitRepeatStatusType.custom: 'custom',
};
