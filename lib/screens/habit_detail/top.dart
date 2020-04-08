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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            habit.name, 
            style: TextStyle(
              fontSize: 24, fontWeight: 
              FontWeight.w500,
              color: GsColors.of(context).black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            habit.remarks == '' ? '暂无备注' : habit.remarks, 
            style: TextStyle(
              fontSize: 14, 
              color: habit.remarks.isEmpty 
                  ? GsColors.of(context).gray :  GsColors.of(context).black,
            ),
          ),
        ],
      ),
    );
  }
}