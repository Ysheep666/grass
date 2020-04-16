import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/motion_group_record.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/icons/icons.dart';

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
      width: 108,
      height: 24,
      alignment: Alignment.center,
      child: Container(
        width: 18,
        height: 3,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey4,
          borderRadius: const BorderRadius.all(Radius.circular(1.5)),
        ),
      )
    ));

    items.addAll(
      widget.motionGroupRecord.content.map(
        (c) => _Input()
      )
    );

    items.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Icon(FeatherIcons.check, size: 20, color: CupertinoColors.label),
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

class _Input extends StatefulWidget {
  const _Input({Key key}) : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<_Input> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Constant.emitter.emit('habit_detail@show_keyboard', _controller);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        alignment: Alignment.center,
        child: CupertinoTextField(
          readOnly: true,
          showCursor: true,
          enableInteractiveSelection: true,
          focusNode: _focusNode,
          controller: _controller, 
          textAlign: TextAlign.center,
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 15,
            height: 1.2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey5,
            border: Border.all(width: 0, color: CupertinoColors.systemGrey5),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }
}
