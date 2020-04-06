import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:provider/provider.dart';

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
  bool _isSubmit = false;
  bool _appBarShadow = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
      await habitDetailStore.didLoad(widget.habit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        final habitDetailStore = Provider.of<HabitDetailStore>(context);
        return Scaffold(
          backgroundColor: GsColors.of(context).background,
          appBar: GsAppBar(
            middle: Center(),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text('关闭', style: TextStyle(fontSize: 15, color: GsColors.of(context).primary)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              color: GsColors.of(context).green,
              minSize: 0,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Text(
                '完成训练',
                style: TextStyle(
                  fontSize: 14,
                  color: _isSubmit ? GsColors.of(context).white : GsColors.of(context).gray,
                ),
              ),
              onPressed: _isSubmit ? () async {
              } : null,
            ),
            shadow: _appBarShadow,
          ),
          body: SafeArea(
            child: habitDetailStore.isLoaded 
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
                      // SliverAnimatedList
                    ],
                  ),
                )
                : Center(),
          ),
        );
      },
    );
  }
}
