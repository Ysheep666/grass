import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';

class HabitGoodResultScreen extends StatefulWidget {
  HabitGoodResultScreen({Key key}) : super(key: key);

  @override
  _HabitGoodResultScreenState createState() => _HabitGoodResultScreenState();
}

class _HabitGoodResultScreenState extends State<HabitGoodResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoDynamicColor.resolve(GsColors.background, context),
      appBar: GsAppBar(
        decoration: BoxDecoration(
          boxShadow: [],
        ),
        middle: Center(),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.clear,
            size: 44,
            color: CupertinoDynamicColor.resolve(CupertinoColors.systemBlue, context),
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text('👍', textAlign: TextAlign.center, style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 36,
          )),
          Text('真棒！', textAlign: TextAlign.center, style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 24,
          )),
          Text('您完成了第 1 次锻炼，请继续保持良好的习惯。', textAlign: TextAlign.center, style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 15,
          ))
        ],
      ),
    );
  }
}