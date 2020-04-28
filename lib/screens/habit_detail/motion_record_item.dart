import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/motion.dart';
import 'package:grass/models/motion_group_record.dart';
import 'package:grass/models/motion_record.dart';
import 'package:grass/stores/base_store.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';

import 'motion_group_record_list.dart';

class MotionRecordItem extends StatefulWidget {
  MotionRecordItem({
    Key key,
    this.motionRecord,
    this.slidableController,
  }) : super(key: key);

  final MotionRecord motionRecord;
  final SlidableController slidableController;

  @override
  _MotionRecordItemState createState() => _MotionRecordItemState();
}

class _MotionRecordItemState extends State<MotionRecordItem> {
  _top(Motion motion) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(motion.name, style: TextStyle(fontSize: 16)),
            onPressed: () {
            },
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(FeatherIcons.more_horizontal, size: 24),
            onPressed: () {
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
                      final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
                      habitDetailStore.addMotionGroupRecord(MotionGroupRecord(
                        motionRecordId: widget.motionRecord.id,
                        content: motion.content,
                      ));
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