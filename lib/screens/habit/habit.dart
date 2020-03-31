import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/screens/habit_edit/habit_edit.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/utils/helper.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'calendar_tile.dart';
import 'habit_cell.dart';

bool _isSelectedAtHabit(DateTime selectedDate, Habit value) {
  if (value.repeatStatusType != HabitRepeatStatusType.custom) {
    return value.repeatStatusValues.indexOf(selectedDate.weekday) != -1;
  }
  final diffDay = calculateDifference(selectedDate, value.createdDate).abs();
  return value.repeatStatusValues[0] == diffDay;
}

class HabitScreen extends StatefulWidget {
  HabitScreen({Key key}) : super(key: key);

  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  DateTime _selectedDate = DateTime.now();
  ItemScrollController _scrollController = ItemScrollController();
  Tween<Offset> _tween = Tween<Offset>(
    begin: Offset(1, 0),
    end: Offset(0, 0),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final habitStore = Provider.of<HabitStore>(context, listen: false);
      await habitStore.didLoad();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GsColors.of(context).background,
      appBar: GsAppBar(
        middle: _appBarMiddle(),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(FeatherIcons.menu, color: GsColors.of(context).gray),
          onPressed: () {
            Constant.emitter.emit('drawer@toggle');
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(FeatherIcons.plus, color: GsColors.of(context).gray),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => HabitEditScreen(habit: Habit())
              ),
            );
          },
        ),
        shadow: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CalendarTile(
              selectedDate: _selectedDate,
              itemScrollController: _scrollController,
              onChanged: (value) {
                setState(() {
                  _selectedDate = value;
                });
              },
            ),
            Expanded(
              child: Material(
                color: GsColors.of(context).background,
                child: SafeArea(
                  child: _content()
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBarMiddle() {
    final items = <Widget>[Text(dateTimeFromNow(_selectedDate, 'yyyy年MM月dd日'))];
    if (calculateDifference(_selectedDate, DateTime.now()).abs() > 1) {
      items.addAll([
        SizedBox(width: 5),
        GestureDetector(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: GsColors.of(context).backgroundGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              height: 20,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '今天', 
                style: TextStyle(fontSize: 12, color: GsColors.of(context).primary),
              ),
            ),
          ),
          onTap: () {
            HapticFeedback.selectionClick();
            _scrollController.scrollTo(index: 30 - calendarTileOffsetIndex, duration: Duration(milliseconds: 200));
            setState(() {
              _selectedDate = DateTime.now();
            });
          },
        ),
      ]);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: items,
    );
  }

  Widget _content() {
    return Observer(
      builder: (BuildContext context) {
        final habitStore = Provider.of<HabitStore>(context);

        if (!habitStore.isLoaded) {
          return Center();
        }

        final items = habitStore.items.where((i) => _isSelectedAtHabit(_selectedDate, i)).toList();
        if (items.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/placeholder.png'),
                width: 160,
                color: GsColors.of(context).gray,
              ),
              SizedBox(height: 20),
              Text(
                '您的任务列表为空\n请点击‘+’创建一个新习惯吧',
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 13, color: GsColors.of(context).gray),
              ),
            ],
          );
        }

        return AnimatedList(
          padding: EdgeInsets.symmetric(vertical: 10),
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) {
            return SlideTransition(
              position: animation.drive(_tween),
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: <Widget>[
                  SlideAction(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(FeatherIcons.trash_2, size: 24, color: GsColors.of(context).red),
                        SizedBox(height: 8),
                        Text('删除', style: TextStyle(color: GsColors.of(context).red))
                      ]
                    ),
                    color: GsColors.of(context).background,
                    onTap: () {
                      
                    },
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: HabitCell(value: items[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
