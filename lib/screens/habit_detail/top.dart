import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/utils/colors.dart';

class Top extends StatelessWidget {
  const Top({
    Key key,
    this.habit,
  }) : super(key: key);

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            habit.name, 
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 24, fontWeight: 
              FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            habit.remarks == '' ? '暂无备注' : habit.remarks,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 16,
              color: habit.remarks.isEmpty 
                  ? CupertinoDynamicColor.resolve(GsColors.grey, context) : null,
            ),
          ),
        ],
      ),
    );
  }
}