import 'package:flutter/material.dart';
import 'package:grass/models/habit.dart';
import 'package:mobx/mobx.dart';

import 'habit_item.dart';

class HabitList extends StatefulWidget {
  const HabitList({
    Key key,
    this.items,
  }) : super(key: key);

  final ObservableList<Habit> items;

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int _initialItemCount = 0;

  @override
  void initState() { 
    super.initState();
    _initialItemCount = widget.items.length;
    widget.items.observe((listChange) {
      if (listChange.added?.isNotEmpty ?? false) {
        _listKey.currentState.insertItem(listChange.index);
      }

      if (listChange.removed?.isNotEmpty ?? false) {
        _listKey.currentState.removeItem(listChange.index,  (BuildContext context, Animation<double> animation) {
          return _buildItem(listChange.removed.first, animation);
        });
      }
    });
  }

  _buildItem(Habit item, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: HabitItem(value: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      padding: EdgeInsets.symmetric(vertical: 10),
      initialItemCount: _initialItemCount,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        if (widget.items.length <= index) {
          return null;
        }
        return _buildItem(widget.items[index], animation);
      },
    );
  }
}
