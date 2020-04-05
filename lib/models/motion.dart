import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:grass/utils/db.dart';
import 'package:json_annotation/json_annotation.dart';

part 'motion.g.dart';

@JsonSerializable()
class Motion extends BaseModel {
  String name;
  String remarks;
  String initials;
  String type;
  String media;
  String thumb;

  Motion({
    int id,
    this.name = '',
    this.remarks = '',
    this.initials = '',
    this.type = '',
    this.media = '',
    this.thumb = '',
  }) : super(id);


  factory Motion.fromJson(Map<String, dynamic> json) => _$MotionFromJson(json);
  Map<String, dynamic> toJson() => _$MotionToJson(this);

  static Future<List<Motion>> getItems() async {
    final jsonString = await rootBundle.loadString('assets/motions.json');
    List<dynamic> json = jsonDecode(jsonString);
    return json.map((item) {
      return Motion.fromJson(item);
    }).toList();
  }
}