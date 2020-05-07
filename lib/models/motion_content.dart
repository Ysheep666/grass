import 'package:grass/utils/helper.dart';
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

  String get inputValue => valueFromNumber(value, category);
  String get defaultInputValue => valueFromNumber(defaultValue, category);

  set inputValue(String inputValue) {
    value = valueToNumber(inputValue, category);
  }

  factory MotionContent.fromJson(Map<String, dynamic> json) => _$MotionContentFromJson(json);
  Map<String, dynamic> toJson() => _$MotionContentToJson(this);

  static String valueFromNumber(double value, MotionCategory category) {
    if (value == null || value == 0.0) {
      return '';
    }
    if (category == MotionCategory.duration) {
      return valueFromDuration(value.toInt());
    }
    return value.toInt().toDouble() == value ? value.toInt().toString() : value.toString();
  }

  static double valueToNumber(String value, MotionCategory category) {
    if (value == null || value == '') {
      return null;
    }
    if (category == MotionCategory.duration) {
      return valueToDuration(value).toDouble();
    }
    return double.parse(value);
  }
}