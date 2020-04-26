import 'package:flutter/material.dart';
import 'package:grass/models/motion_group_record.dart';
import 'package:grass/models/motion_record.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'motion_group_record_item.dart';

class MotionGroupRecordList extends StatefulWidget {
  MotionGroupRecordList({
    Key key,
    this.motionRecord,
  }) : super(key: key);

  final MotionRecord motionRecord;

  @override
  _MotionGroupRecordListState createState() => _MotionGroupRecordListState();
}

class _MotionGroupRecordListState extends State<MotionGroupRecordList> {
  ObservableList<MotionGroupRecord> _motionGroupRecords;

  @override
  void initState() {
    final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
    _motionGroupRecords = habitDetailStore.motionGroupRecords;
    _motionGroupRecords.observe((listChange) {
      if (!habitDetailStore.isLoaded) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = _motionGroupRecords
        .where((r) => r.motionRecordId == widget.motionRecord.id)
        .toList().asMap().entries
        .map((entry) => MotionGroupRecordItem(
          index: entry.key,
          motionGroupRecord: entry.value,
        ))
        .toList();
    return Container(
       child: Column(
         children: items
       ),
    );
  }
}