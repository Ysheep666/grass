import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/screens/habit_edit/habit_edit.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/bridge/native_widget.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/utils/helper.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';

import 'calendar_tile.dart';
import 'habit_list.dart';

class HabitScreen extends StatefulWidget {
  HabitScreen({Key key}) : super(key: key);

  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  CalendarTileController _controller = CalendarTileController();

  _didLoad() async {
    final habitStore = Provider.of<HabitStore>(context, listen: false);
    await habitStore.didLoad();
  }

  Widget _appBarMiddle(DateTime selectedDate) {
    final items = <Widget>[Text(dateTimeFromNow(selectedDate, 'yyyy年MM月dd日'))];
    if (calculateDifference(selectedDate, DateTime.now()).abs() > 1) {
      items.addAll([
        SizedBox(width: 5),
        GestureDetector(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: CupertinoDynamicColor.resolve(GsColors.grey2, context),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Container(
              height: 20,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '今天',
                style: TextStyle(fontSize: 12, color: GsColors.primary),
              ),
            ),
          ),
          onTap: () {
            NativeMethod.impactFeedback(ImpactFeedbackStyle.soft);
            Constant.emitter.emit('habit@close_slidable');
            final habitStore = Provider.of<HabitStore>(context, listen: false);
            habitStore.setSelectedDate(DateTime.now());
            _controller.goToday();
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

  Widget _placeholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage('assets/images/placeholder.png'),
          width: 160,
          color: CupertinoDynamicColor.resolve(GsColors.grey, context),
        ),
        SizedBox(height: 50),
        Text(
          '您的任务列表为空\n请点击‘+’创建一个新习惯吧',
          textAlign: TextAlign.center, 
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 14, 
            color: CupertinoDynamicColor.resolve(GsColors.grey, context),
          ),
        ),
        SizedBox(height: 120),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _didLoad(),
      builder: (context, snapshot) {
        return Observer(
          builder: (BuildContext context) {
            final habitStore = Provider.of<HabitStore>(context);
            return Scaffold(
              backgroundColor: CupertinoDynamicColor.resolve(GsColors.background, context),
              appBar: GsAppBar(
                decoration: BoxDecoration(boxShadow: []),
                middle: _appBarMiddle(habitStore.selectedDate),
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(FeatherIcons.menu, size: 24, color: CupertinoDynamicColor.resolve(GsColors.grey, context)),
                  onPressed: () {
                    Constant.emitter.emit('drawer@toggle');
                    Constant.emitter.emit('habit@close_slidable');
                  },
                ),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(FeatherIcons.plus, size: 24, color: CupertinoDynamicColor.resolve(GsColors.grey, context)),
                  onPressed: () async {
                    Constant.emitter.emit('habit@close_slidable');
                    NativeMethod.impactFeedback(ImpactFeedbackStyle.light);
                    final habit = await Navigator.of(context).push(
                      CupertinoPageRoute<Habit>(
                        builder: (context) => HabitEditScreen(habit: Habit())
                      ),
                    );
                    if (habit != null) {
                      await habitStore.save(habit);
                      NativeMethod.notificationFeedback(NotificationFeedbackType.success);
                      NativeWidget.toast('✌️保存成功✌️');
                    }
                  },
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CalendarTile(
                    selectedDate: habitStore.selectedDate,
                    controller: _controller,
                  ),
                  Expanded(
                    child: Material(
                      color: CupertinoDynamicColor.resolve(GsColors.background, context),
                      child: habitStore.isLoaded
                          ? habitStore.habits.isEmpty ? _placeholder() : HabitList()
                          : Center(),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}
