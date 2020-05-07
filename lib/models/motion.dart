import 'package:grass/utils/db.dart';
import 'package:grass/utils/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'motion_content.dart';

part 'motion.g.dart';

@JsonSerializable()
class Motion extends BaseModel {
  String name;
  String remarks;
  String initials;
  String type;
  String media;
  String thumb;

  @JsonKey(fromJson: valuesFromJson, toJson: valuesToJson)
  List<MotionContent> content;

  Motion({
    int id,
    this.name = '',
    this.remarks = '',
    this.initials = '',
    this.type = '',
    this.media = '',
    this.thumb = '',
    this.content,
  }) : super(id) {
    this.content ??= [];
  }

  factory Motion.fromJson(Map<String, dynamic> json) => _$MotionFromJson(json);
  Map<String, dynamic> toJson() => _$MotionToJson(this);
}
