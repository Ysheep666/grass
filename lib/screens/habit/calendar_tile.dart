import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const calendarTileOffsetIndex = 3;

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
      .scrollTo(index: 30 - calendarTileOffsetIndex, duration: Duration(milliseconds: 200));
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
  DateTime _startDate = _getStartDate();
  final ItemScrollController _scrollController = ItemScrollController();

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
        initialScrollIndex: 30 - calendarTileOffsetIndex,
        scrollDirection: Axis.horizontal,
        itemScrollController: _scrollController,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final date = _startDate.add(Duration(days: index));
          final isSelected = Utils.isSameDay(date, widget.selectedDate);
          final color = isSelected ? GsColors.of(context).primary : GsColors.of(context).grayB;
          final backgroundColor = GsColors.of(context).backgroundGray;
          final borderColor = isSelected ? GsColors.of(context).primary : GsColors.of(context).backgroundGray;
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            child: Ink(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: 42,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(DateFormat('EEE', 'zh_CH').format(date), style: TextStyle(fontSize: 12, color: color)),
                    Text(DateFormat('dd', 'zh_CH').format(date), style: TextStyle(fontSize: 14, color: color)),
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
        itemCount: 365,
      ),
    );
  }
}
