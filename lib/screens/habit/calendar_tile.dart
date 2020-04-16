import 'package:date_utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const _calendarDaysCount = 365;
const _calendarDaysInitIndex = 30;

_getStartDate() => DateTime.now().add(Duration(days: -30));

class CalendarTileController {
  _CalendarTileState _calendarTileState;

  void _attach(_CalendarTileState calendarTileState) {
    assert(_calendarTileState == null);
    _calendarTileState = calendarTileState;
  }

  void _detach() {
    assert(_calendarTileState != null);
    _calendarTileState = null;
  }

  goToday() {
    _calendarTileState
      ._scrollController
      .scrollTo(index: _calendarDaysInitIndex, alignment: 0.45, duration: Duration(milliseconds: 200));
  }
}

class CalendarTile extends StatefulWidget {
  CalendarTile({
    Key key,
    this.selectedDate,
    this.controller,
  }) : super(key: key);

  final DateTime selectedDate;
  final CalendarTileController controller;

  @override
  _CalendarTileState createState() => _CalendarTileState();
}

class _CalendarTileState extends State<CalendarTile> {
  final ItemScrollController _scrollController = ItemScrollController();
  DateTime _startDate = _getStartDate();

  @override
  void initState() {
    super.initState();
    _startDate = _getStartDate();
    widget.controller?._attach(this);
  }

  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      child: ScrollablePositionedList.separated(
        initialScrollIndex: _calendarDaysInitIndex,
        initialAlignment: 0.45,
        scrollDirection: Axis.horizontal,
        itemScrollController: _scrollController,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final date = _startDate.add(Duration(days: index));
          final isSelected = Utils.isSameDay(date, widget.selectedDate);
          final color = isSelected ? GsColors.of(context).primary : CupertinoColors.systemGrey2;
          final backgroundColor = CupertinoColors.systemGrey6;
          final borderColor = isSelected ? GsColors.of(context).primary : CupertinoColors.systemGrey6;
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: SizedBox(
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      DateFormat('EEE', 'zh_CH').format(date), 
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 12, color: color),
                    ),
                    Text(
                      DateFormat('dd', 'zh_CH').format(date),
                      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 14, color: color),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Constant.emitter.emit('habit@close_slidable');
              NativeMethod.impactFeedback(ImpactFeedbackStyle.soft);
              final habitStore = Provider.of<HabitStore>(context, listen: false);
              habitStore.setSelectedDate(date);
            },
          );
        }, 
        separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10), 
        itemCount: _calendarDaysCount,
      ),
    );
  }
}
