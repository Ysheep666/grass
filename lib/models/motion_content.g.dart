// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotionContent _$MotionContentFromJson(Map<String, dynamic> json) {
  return MotionContent(
    category: _$enumDecodeNullable(_$MotionCategoryEnumMap, json['category']),
    value: (json['value'] as num)?.toDouble(),
    defaultValue: (json['defaultValue'] as num)?.toDouble(),
  )..inputValue = json['inputValue'] as String;
}

Map<String, dynamic> _$MotionContentToJson(MotionContent instance) =>
    <String, dynamic>{
      'category': _$MotionCategoryEnumMap[instance.category],
      'value': instance.value,
      'defaultValue': instance.defaultValue,
      'inputValue': instance.inputValue,
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

const _$MotionCategoryEnumMap = {
  MotionCategory.weight: 'weight',
  MotionCategory.distance: 'distance',
  MotionCategory.number: 'number',
  MotionCategory.duration: 'duration',
};
