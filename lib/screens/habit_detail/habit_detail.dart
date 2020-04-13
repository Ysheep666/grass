import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/bridge/native_widget.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:provider/provider.dart';

import 'motion_record_list.dart';
import 'top.dart';
class HabitDetailScreen extends StatefulWidget {
  HabitDetailScreen({
    Key key,
    @required this.habit,
  }) : super(key: key);

  final Habit habit;

  @override
  HabitDetailScreenState createState() => HabitDetailScreenState();
}

class HabitDetailScreenState extends State<HabitDetailScreen> {
  HabitDetailStore _habitDetailStore;
  bool _isSubmit = false;
  bool _appBarShadow = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
      await _habitDetailStore.didLoad(widget.habit);
    });
  }

  @override
  void deactivate() {
    Future.delayed(Duration.zero, () async {
      _habitDetailStore?.clear();
      _habitDetailStore = null;
    });
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        final habitDetailStore = Provider.of<HabitDetailStore>(context);
        return Scaffold(
          backgroundColor: CupertinoColors.systemBackground,
          appBar: GsAppBar(
            shadow: _appBarShadow,
            middle: Center(),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text('关闭', style: CupertinoTheme.of(context).textTheme.actionTextStyle),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            trailing: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              color: GsColors.of(context).green,
              minSize: 0,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Text(
                '完成训练',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 14,
                  color: _isSubmit ? CupertinoColors.white : CupertinoColors.systemGrey4,
                ),
              ),
              onPressed: _isSubmit ? () async {
              } : null,
            ),
          ),
          body: habitDetailStore.isLoaded 
              ? NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  final shadow = notification.metrics.pixels > 0;
                  if (_appBarShadow != shadow) {
                    setState(() {
                      _appBarShadow = shadow;
                    });
                  }
                  return true;
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Top(habit: habitDetailStore.habit),
                    ),
                    habitDetailStore.isLoaded ? MotionRecordList() : Center(),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10, 
                          left: 20, 
                          right: 20, 
                          bottom: 10 + MediaQuery.of(context).padding.bottom,
                        ),
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          color: GsColors.of(context).primary,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          minSize: 0,
                          child: Text(
                            '添加动作',
                            style: TextStyle(
                              fontSize: 15,
                              color: CupertinoColors.white,
                            ),
                          ),
                          onPressed: () async {
                            final ids = await NativeWidget.motionPicker();
                            habitDetailStore.addMotionsByIds(ids);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Center(),
        );
      },
    );
  }
}
