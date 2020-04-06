import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:grass/utils/db.dart';
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

  static Future<List<Motion>> getItems() async {
    final jsonString = await rootBundle.loadString('assets/motions.json');
    final json = jsonDecode(jsonString);
    return (json as List).map((e) => Motion.fromJson(e)).toList();
  }
}
