import 'package:flutter/material.dart';

class GsColors {
  static GsColors of(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GsColors(isLight);
  }

  GsColors(this.isLight);
  bool isLight;

  Color get primary => isLight ? Color(0xFF409EFF) : Color(0xFF409EFF);
  Color get red => isLight ? Color(0xFFEC352D) : Color(0xFFEC352D);
  Color get green => isLight ? Color(0xFF00CF67) : Color(0xFFEC352D);
}
