// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Motion _$MotionFromJson(Map<String, dynamic> json) {
  return Motion(
    id: json['id'] as int,
    name: json['name'] as String,
    remarks: json['remarks'] as String,
    initials: json['initials'] as String,
    type: json['type'] as String,
    media: json['media'] as String,
    thumb: json['thumb'] as String,
    content: valuesFromJson(json['content'] as String),
  );
}

Map<String, dynamic> _$MotionToJson(Motion instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'remarks': instance.remarks,
      'initials': instance.initials,
      'type': instance.type,
      'media': instance.media,
      'thumb': instance.thumb,
      'content': valuesToJson(instance.content),
    };
