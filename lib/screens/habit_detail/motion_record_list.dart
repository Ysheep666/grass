import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/motion_record.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/utils/helper.dart';
import 'package:grass/widgets/animation/switch_box.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'habit_detail.dart';
import 'motion_record_item.dart';

const _kDuration = Duration(milliseconds: 200);

class MotionRecordList extends StatefulWidget {
  const MotionRecordList({
    Key key,
  }) : super(key: key);

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

  bool _switching = false;
  OverlayEntry _overlayEntry;
  
  Map<int, GlobalKey<State>> _itemKeys = {};
  HabitDetailItemSwitchData _switchData;
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
        _listKey.currentState?.insertItem(listChange.index, duration: _kDuration);
      }

      if (listChange.removed?.isNotEmpty ?? false) {
        _listKey.currentState?.removeItem(listChange.index,  (BuildContext context, Animation<double> animation) {
          return _buildItem(listChange.removed.first, animation);
        }, duration: _kDuration);
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

  _switchOverlay(Offset start, Offset end, Widget child) async {
    final c = Completer();
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          bottom: null,
          child: SwitchBox(
            autoStart: true,
            start: start,
            end: end,
            child: child,
            completed: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
              c.complete();
            },
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry);
    return c.future;
  }
  
  _switch(HabitDetailItemSwitchData value) async {
    _switching = true;
    final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
    final index = _motionRecords.indexOf(value.motionRecord);
    final switchIndex = value.type == HabitDetailItemSwitchType.up ? index - 1 : index + 1;
    if (switchIndex > -1 && switchIndex < _motionRecords.length) {
      _switchData = value;
      RenderBox currentBox = _itemKeys[value.motionRecord.id].currentContext.findRenderObject();
      RenderBox switchBox = _itemKeys[_motionRecords[switchIndex].id].currentContext.findRenderObject();
      final start = currentBox.localToGlobal(Offset.zero);
      final end = Offset(
        start.dx, 
        start.dy + (value.type == HabitDetailItemSwitchType.up ? - switchBox.size.height : switchBox.size.height),
      );

      final image = await capturePng(_itemKeys[value.motionRecord.id]);
      Future.delayed(Duration.zero, () async {
        await _switchOverlay(start, end, Image.memory(
          image,
          height: currentBox.size.height,
          width: currentBox.size.width,
        ));
        setState(() {
          _switching = false;
          _switchData = null;
        });
      });
      habitDetailStore.moveMotionRecord(index, switchIndex);
      NativeMethod.impactFeedback(ImpactFeedbackStyle.light);
    }
  }

  _buildItem(MotionRecord record, Animation<double> animation) {
    if (_switching) {
      _itemKeys[record.id] = GlobalKey<State>();
    }
    _itemKeys[record.id] ??= GlobalKey<State>();
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        axisAlignment: -1,
        child: Visibility(
          visible: _switchData?.motionRecord != record,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: RepaintBoundary(
            key: _itemKeys[record.id],
            child: MotionRecordItem(
              motionRecord: record,
              slidableController: _slidableController,
              onSwitch: (value) => _switch(value),
            ),
          ),
        ),
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