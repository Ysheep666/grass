import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';

class HabitDetailScreen extends StatefulWidget {
  HabitDetailScreen({
    Key key,
    @required this.habit,
  }) : super(key: key);

  final Habit habit;

  @override
  HabitDetailScreenState createState() => HabitDetailScreenState();
}

class HabitDetailScreenState extends State<HabitDetailScreen> {
  // Habit _value;
  bool _isSubmit = false;

  @override
  void initState() {
    super.initState();
    // _value = widget.habit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GsColors.of(context).background,
      appBar: GsAppBar(
        middle: Center(),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('关闭', style: TextStyle(fontSize: 15, color: GsColors.of(context).primary)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
          color: GsColors.of(context).green,
          minSize: 0,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Text(
            '完成训练',
            style: TextStyle(
              fontSize: 14,
              color: _isSubmit ? GsColors.of(context).white : GsColors.of(context).gray,
            )
          ),
          onPressed: _isSubmit ? () async {
          } : null,
        ),
        shadow: false,
      ),
      body: SafeArea(
        child: Center(
        ),
      ),
    );
  }
}
