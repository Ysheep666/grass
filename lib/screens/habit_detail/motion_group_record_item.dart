import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/motion_group_record.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/animation/scale_box.dart';
import 'package:grass/widgets/animation/shake_box.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';

import 'item_input.dart';

class MotionGroupRecordItem extends StatefulWidget {
  MotionGroupRecordItem({
    Key key,
    this.index,
    this.motionGroupRecord,
    this.slidableController,
  }) : super(key: key);

  final int index;
  final MotionGroupRecord motionGroupRecord;
  final SlidableController slidableController;

  @override
  _MotionGroupRecordItemState createState() => _MotionGroupRecordItemState();
}

class _MotionGroupRecordItemState extends State<MotionGroupRecordItem> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _itemScaleBoxKey = GlobalKey<ScaleBoxState>();
  final _checkShakeBoxKey = GlobalKey<ShakeBoxState>();

  _update(MotionGroupRecord motionGroupRecord) {
    final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
    habitDetailStore.updateMotionGroupRecord(motionGroupRecord);
  }

  _delete(MotionGroupRecord motionGroupRecord) {
    final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
    habitDetailStore.removeMotionGroupRecord(motionGroupRecord);
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.motionGroupRecord.isDone;
    TextStyle headerTextStyle = CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );

    List<Widget> items = [];
    items.add(Container(
      width: 30,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDone ? null : CupertinoDynamicColor.resolve(GsColors.grey2, context),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Text('${widget.index + 1}', style: headerTextStyle),
    ));

    items.add(Container(
      width: 100,
      height: 24,
      alignment: Alignment.center,
      child: Container(
        width: 18,
        height: 3,
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(GsColors.grey, context),
          borderRadius: const BorderRadius.all(Radius.circular(1.5)),
        ),
      )
    ));

    items.addAll(
      widget.motionGroupRecord.content.map((content) {
        return ItemInput(
          content: content,
          decoration: InputDecoration(
            hintText: content.defaultInputValue,
            hintStyle: TextStyle(
              color: CupertinoDynamicColor.resolve(CupertinoColors.placeholderText, context),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 1).copyWith(left: 2),
            filled: true,
            fillColor: isDone ? Colors.transparent : CupertinoDynamicColor.resolve(GsColors.grey2, context),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
          ),
          onChanged: (value) {
            content.inputValue = value;
            if (content.value == null || content.value == 0.0) {
              widget.motionGroupRecord.isDone = false;
            }
            _update(widget.motionGroupRecord);
          },
        );
      })
    );

    items.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ShakeBox(
        key: _checkShakeBoxKey,
        child: CupertinoButton(
          padding: const EdgeInsets.all(0),
          color: isDone ? CupertinoDynamicColor.resolve(GsColors.green, context) : CupertinoDynamicColor.resolve(GsColors.grey2, context),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          minSize: 0,
          child: Container(
            width: 30,
            height: 24,
            alignment: Alignment.center,
            child: Icon(FeatherIcons.check, size: 20, color: 
              isDone ? Colors.white : CupertinoDynamicColor.resolve(CupertinoColors.label, context),
            ),
          ),
          onPressed: () {
            Constant.emitter.emit('habit_detail@close_slidable');
            if (_formKey.currentState.validate()) {
              widget.motionGroupRecord.isDone = !isDone;
              _update(widget.motionGroupRecord);
              NativeMethod.notificationFeedback(NotificationFeedbackType.success);
              if (widget.motionGroupRecord.isDone) {
                _itemScaleBoxKey.currentState.start();
              }
            } else {
              NativeMethod.notificationFeedback(NotificationFeedbackType.error);
              _checkShakeBoxKey.currentState.start();
            }
          },
        ),
      ),
    ));

    return ClipRect(
      child: Slidable(
        controller: widget.slidableController,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          SlideAction(
            child: Text('删除', style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
            color: GsColors.red,
            onTap: () => _delete(widget.motionGroupRecord),
          ),
        ],
        child: ClipRect(
          child: ScaleBox(
            key: _itemScaleBoxKey,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: isDone ? CupertinoDynamicColor.resolve(GsColors.green, context).withOpacity(0.15) : null,
              child: Form(
                key: _formKey,
                child: Row(
                  children: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


