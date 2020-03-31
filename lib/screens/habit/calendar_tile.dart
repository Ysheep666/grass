import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grass/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const calendarTileOffsetIndex = 3;

_getStartDate() => DateTime.now().add(Duration(days: -30));

class CalendarTile extends StatefulWidget {
  CalendarTile({
    Key key,
    this.selectedDate,
    this.onChanged,
    this.itemScrollController,
  }) : super(key: key);

  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final ItemScrollController itemScrollController;

  @override
  _CalendarTileState createState() => _CalendarTileState();
}

class _CalendarTileState extends State<CalendarTile> {
  DateTime _startDate = _getStartDate();

  @override
  void initState() {
    super.initState();
    _startDate = _getStartDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      child: ScrollablePositionedList.separated(
        initialScrollIndex: 30 - calendarTileOffsetIndex,
        scrollDirection: Axis.horizontal,
        itemScrollController: widget.itemScrollController,
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
              HapticFeedback.selectionClick();
              widget.onChanged(date);
            },
          );
        }, 
        separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10), 
        itemCount: 365,
      ),
    );
  }
}
