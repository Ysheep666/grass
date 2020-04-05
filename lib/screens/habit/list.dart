import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/utils/constant.dart';
import 'package:mobx/mobx.dart';

import 'item.dart';

class List extends StatefulWidget {
  const List({
    Key key,
    this.items,
  }) : super(key: key);

  final ObservableList<Habit> items;

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int _initialItemCount = 0;
  SlidableController _slidableController = SlidableController();

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

    Constant.emitter.on('habit@close_slidable', _closeSlidable);
  }

  @override
  void dispose() {
    Constant.emitter.off('habit@close_slidable', _closeSlidable);
    super.dispose();
  }

  _closeSlidable(data) {
    _slidableController.activeState?.close();
  }

  _buildItem(Habit item, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: Item(habit: item, slidableController: _slidableController),
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
