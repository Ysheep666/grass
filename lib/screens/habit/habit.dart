import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/screens/habit_edit/habit_edit.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/icons/icons.dart';

class HabitScreen extends StatefulWidget {
  HabitScreen({Key key}) : super(key: key);

  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GsColors.of(context).background,
      appBar: GsAppBar(
        middle: Text('健身小助手'),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }
}
