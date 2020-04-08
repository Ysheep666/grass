import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/screens/motion/motion.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/helper.dart';

class MotionPicker extends StatefulWidget {
  MotionPicker({
    Key key,
    this.onChanged,
  }) : super(key: key);

  final ValueChanged<Map> onChanged;

  @override
  MotionPickerState createState() => MotionPickerState();
}

class MotionPickerState extends State<MotionPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GsColors.of(context).background,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: getModalBottomSheetHeight(16),
        child: MotionScreen(),
      ),
    );
  }
}
