import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/models/motion.dart';
import 'package:grass/models/motion_content.dart';
import 'package:grass/models/motion_record.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';

class MotionRecordItem extends StatefulWidget {
  MotionRecordItem({
    Key key,
    this.motionRecord,
  }) : super(key: key);

  final MotionRecord motionRecord;

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
    TextStyle defaultStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );
    List<Widget> items = [];
    items.addAll([
      SizedBox(width: 30, child: Text('组', textAlign: TextAlign.center, style: defaultStyle)),
      SizedBox(width: 100, child: Text('上一次', textAlign: TextAlign.center, style: defaultStyle)),
    ]);
    items.addAll(motion.content.map((c) => 
      Expanded(
        flex: 1,
        child: Text(MotionCategoryEnumMap[c.category], textAlign: TextAlign.center, style: defaultStyle),
      ),
    ).toList());
    items.addAll([
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Icon(FeatherIcons.check, size: 20, color: CupertinoColors.label),
      ),
    ]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground,
              boxShadow: [BoxShadow(
                color: CupertinoColors.systemGrey.withOpacity(0.2),
                offset: Offset(0, 1),
                blurRadius: 10,
                spreadRadius: 1,
              )],
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: <Widget>[
                _top(motion),
                _header(motion),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    color: CupertinoColors.systemGrey5,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    minSize: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FeatherIcons.plus, size: 16, color: CupertinoColors.label),
                        Text(
                          '添加组',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.label,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
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