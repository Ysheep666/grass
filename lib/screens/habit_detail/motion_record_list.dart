import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/motion_record.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/constant.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'motion_record_item.dart';

class MotionRecordList extends StatefulWidget {
  const MotionRecordList({Key key}) : super(key: key);

  @override
  _MotionRecordListState createState() => _MotionRecordListState();
}

class _MotionRecordListState extends State<MotionRecordList> {
  final _listKey = GlobalKey<SliverAnimatedListState>();
  SlidableController _slidableController = SlidableController(
    onSlideAnimationChanged: (value) {},
    onSlideIsOpenChanged: (value) {
      if (value) {
        Constant.emitter.emit('habit_detail@hide_keyboard');
      }
    },
  );
  ObservableList<MotionRecord> _motionRecords;

  @override
  void initState() {
    final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
    _motionRecords = habitDetailStore.motionRecords;
    _motionRecords.observe((listChange) {
      if (!habitDetailStore.isLoaded) {
        return;
      }

      if (listChange.added?.isNotEmpty ?? false) {
        _listKey.currentState?.insertItem(listChange.index);
      }

      if (listChange.removed?.isNotEmpty ?? false) {
        _listKey.currentState?.removeItem(listChange.index,  (BuildContext context, Animation<double> animation) {
          return _buildItem(listChange.removed.first, animation);
        });
      }
    });
    Constant.emitter.on('habit_detail@close_slidable', _closeSlidable);
    super.initState();
  }


  @override
  void dispose() {
    Constant.emitter.off('habit_detail@close_slidable', _closeSlidable);
    super.dispose();
  }

  _closeSlidable(data) {
    _slidableController.activeState?.close();
  }

  _buildItem(MotionRecord record, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: MotionRecordItem(
        motionRecord: record,
        slidableController: _slidableController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: _motionRecords.length,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        if (_motionRecords.length <= index) {
          return null;
        }
        return _buildItem(_motionRecords[index], animation);
      },
    );
  }
}