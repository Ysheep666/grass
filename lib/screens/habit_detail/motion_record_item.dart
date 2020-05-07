import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/motion.dart';
import 'package:grass/models/motion_record.dart';
import 'package:grass/stores/base_store.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/bridge/native_widget.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';

import 'habit_detail.dart';
import 'motion_group_record_list.dart';

class MotionRecordItem extends StatefulWidget {
  MotionRecordItem({
    Key key,
    this.motionRecord,
    this.slidableController,
    this.onSwitch,
  }) : super(key: key);

  final MotionRecord motionRecord;
  final SlidableController slidableController;
  final ValueChanged<HabitDetailItemSwitchData> onSwitch;

  @override
  _MotionRecordItemState createState() => _MotionRecordItemState();
}

class _MotionRecordItemState extends State<MotionRecordItem> {
  final _moerButtonKey = GlobalKey<State>();

  _up() async {
    widget.onSwitch(HabitDetailItemSwitchData(
      type: HabitDetailItemSwitchType.up,
      motionRecord: widget.motionRecord,
    ));
  }

  _down() async {
    widget.onSwitch(HabitDetailItemSwitchData(
      type: HabitDetailItemSwitchType.down,
      motionRecord: widget.motionRecord,
    ));
  }

  _delete() async {
    final result = await NativeWidget.alert(
      title: '您确定要删除运动吗？',
      message: '将删除此运动的所有组，不可恢复。',
      actions: [
        AlertAction(value: 'ok', title: '确定'),
        AlertAction(value: 'cancel', title: '取消', style: AlertActionStyle.cancel),
      ]
    );
    if (result == 'ok') {
      final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
      habitDetailStore.removeMotionRecord(widget.motionRecord);
      NativeMethod.notificationFeedback(NotificationFeedbackType.success);
    }
  }

  _top(Motion motion) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(motion.name, style: TextStyle(fontSize: 16)),
            onPressed: () async {
              NativeWidget.motionDetail(motion);
            },
          ),
          CupertinoButton(
            key: _moerButtonKey,
            padding: EdgeInsets.zero,
            child: Icon(FeatherIcons.more_horizontal, size: 24),
            onPressed: () async {
              Constant.emitter.emit('habit_detail@hide_keyboard');
              Constant.emitter.emit('habit_detail@close_slidable');
              final result = await NativeWidget.alert(
                preferredStyle: AlertPreferredStyle.actionSheet,
                actions: [
                  AlertAction(value: 'up', title: '上移'),
                  AlertAction(value: 'down', title: '下移'),
                  AlertAction(value: 'delete', title: '删除运动'),
                  AlertAction(value: 'cancel', title: '取消', style: AlertActionStyle.cancel),
                ],
              );
              if (result == 'up') {
                await _up();
              } else if (result == 'down') {
                await _down();
              } else if (result == 'delete') {
                await _delete();
              }
            },
          ),
        ],
      ),
    );
  }

  _header(Motion motion) {
    final baseStore = Provider.of<BaseStore>(context, listen: false);
    TextStyle headerTextStyle = CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );

    List<Widget> items = [];
    items.addAll([
      SizedBox(width: 30, child: Text('组', textAlign: TextAlign.center, style: headerTextStyle)),
      SizedBox(width: 100, child: Text('上一次', textAlign: TextAlign.center, style: headerTextStyle)),
    ]);
    items.addAll(motion.content.map((c) => 
      Expanded(
        flex: 1,
        child: Text(baseStore.getMotionCategoryLabel(c.category), textAlign: TextAlign.center, style: headerTextStyle),
      ),
    ).toList());
    items.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 30,
        height: 24,
        alignment: Alignment.center,
        child: Icon(FeatherIcons.check, size: 20, color: CupertinoDynamicColor.resolve(CupertinoColors.label, context)),
      ),
    ));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        final habitDetailStore = Provider.of<HabitDetailStore>(context);
        final motion = habitDetailStore.motions.firstWhere((m) => m.id == widget.motionRecord.motionId);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoDynamicColor.resolve(GsColors.boxBackground, context),
              boxShadow: [
                BoxShadow(
                  color: CupertinoDynamicColor.resolve(GsColors.shadowColor, context),
                  offset: Offset(0, 1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: <Widget>[
                _top(motion),
                _header(motion),
                MotionGroupRecordList(
                  motionRecord: widget.motionRecord,
                  slidableController: widget.slidableController,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    color: CupertinoDynamicColor.resolve(GsColors.grey2, context),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    minSize: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FeatherIcons.plus,
                          size: 16,
                          color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
                        ),
                        Text(
                          '添加组',
                          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      Constant.emitter.emit('habit_detail@close_slidable');
                      NativeMethod.impactFeedback(ImpactFeedbackStyle.light);
                      final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
                      habitDetailStore.addMotionGroupRecord(motion, widget.motionRecord.id);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}