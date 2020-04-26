import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/constant.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'habit_item.dart';

class HabitList extends StatefulWidget {
  const HabitList({Key key}) : super(key: key);

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  final _listKey = GlobalKey<AnimatedListState>();
  final _slidableController = SlidableController();
  ObservableList<Habit> _habits;

  @override
  void initState() { 
    final habitStore = Provider.of<HabitStore>(context, listen: false);
    _habits = habitStore.habits;
    _habits.observe((listChange) {
      if (!habitStore.isLoaded) {
        return;
      }
      if (listChange.added?.isNotEmpty ?? false) {
        _listKey.currentState.insertItem(listChange.index);
      }
      if (listChange.removed?.isNotEmpty ?? false) {
        _listKey.currentState.removeItem(listChange.index,  (BuildContext context, Animation<double> animation) {
          return _buildItem(listChange.removed.first, animation);
        });
      }
    });
    Constant.emitter.on('habit@close_slidable', _closeSlidable);
    super.initState();
  }

  @override
  void dispose() {
    Constant.emitter.off('habit@close_slidable', _closeSlidable);
    super.dispose();
  }

  _closeSlidable(data) {
    _slidableController.activeState?.close();
  }

  _buildItem(Habit habit, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: HabitItem(habit: habit, slidableController: _slidableController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      padding: EdgeInsets.only(bottom: 10 + MediaQuery.of(context).padding.bottom),
      initialItemCount: _habits.length,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        if (_habits.length <= index) {
          return null;
        }
        return _buildItem(_habits[index], animation);
      },
    );
  }
}
