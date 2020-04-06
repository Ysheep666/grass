import 'package:json_annotation/json_annotation.dart';

part 'motion_content.g.dart';

enum MotionCategory {
  weight,
  distance,
  number,
  duration,
}

@JsonSerializable()
class MotionContent {
  MotionCategory category;
  double value;
  double defaultValue;

  MotionContent({
    this.category = MotionCategory.weight,
    this.value,
    this.defaultValue,
  });


  factory MotionContent.fromJson(Map<String, dynamic> json) => _$MotionContentFromJson(json);
  Map<String, dynamic> toJson() => _$MotionContentToJson(this);
}