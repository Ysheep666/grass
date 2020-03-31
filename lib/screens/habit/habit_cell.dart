import 'package:flutter/material.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/utils/colors.dart';

class HabitCell extends StatelessWidget {
  const HabitCell({
    Key key,
    this.value,
  }) : super(key: key);

  final Habit value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: GsColors.of(context).white,
          boxShadow: [BoxShadow(
            color: GsColors.of(context).black.withOpacity(0.1),
            offset: Offset(0, 1),
            blurRadius: 8,
            spreadRadius: 2,
          )],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Text(value.name, style: TextStyle(fontSize: 21)),
                  ),
                  Text(
                    '已完成次数',
                    style: TextStyle(fontSize: 12, color: GsColors.of(context).grayB),
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      value.remarks.isEmpty ? '暂无备注' : value.remarks,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: GsColors.of(context).grayB,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text('0', textAlign: TextAlign.right, style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        print('love');
      },
    );
  }
}