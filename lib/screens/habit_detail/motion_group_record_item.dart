import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/motion_group_record.dart';

class MotionGroupRecordItem extends StatefulWidget {
  MotionGroupRecordItem({
    Key key,
    this.index,
    this.motionGroupRecord,
  }) : super(key: key);

  final int index;
  final MotionGroupRecord motionGroupRecord;

  @override
  _MotionGroupRecordItemState createState() => _MotionGroupRecordItemState();
}

class _MotionGroupRecordItemState extends State<MotionGroupRecordItem> {
  TextStyle _defaultTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    items.add(Container(
      width: 30,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Text('${widget.index + 1}', style: _defaultTextStyle),
    ));

    items.add(Container(
      width: 100,
      height: 24,
      alignment: Alignment.center,
      child: Container(
        width: 24,
        height: 3,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey4,
          borderRadius: const BorderRadius.all(Radius.circular(1.5)),
        ),
      )
    ));

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: items,
      ),
    );
  }
}
