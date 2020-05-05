import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _calendarController = CalendarController();

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoDynamicColor.resolve(GsColors.background, context),
      appBar: GsAppBar(
        decoration: BoxDecoration(boxShadow: []),
        middle: Text('日历'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(FeatherIcons.menu, size: 24, color: CupertinoDynamicColor.resolve(GsColors.grey, context)),
          onPressed: () {
            Constant.emitter.emit('drawer@toggle');
            Constant.emitter.emit('habit@close_slidable');
          },
        ),
      ),
      body: TableCalendar(
        calendarController: _calendarController,
        locale: 'zh_CN',
        headerStyle: HeaderStyle(
          leftChevronIcon: Icon(FeatherIcons.chevron_left, color: CupertinoDynamicColor.resolve(GsColors.grey, context)),
          rightChevronIcon: Icon(FeatherIcons.chevron_right, color: CupertinoDynamicColor.resolve(GsColors.grey, context)),
        ),
      ),
    );
  }
}