import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/helper.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';

class HabitItem extends StatelessWidget {
  const HabitItem({
    Key key,
    this.value,
  }) : super(key: key);

  final Habit value;

  SlideAction _action({IconData icon, String caption, Color color, Color foregroundColor, VoidCallback onTap}) {
    return SlideAction(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 20, color: foregroundColor),
          SizedBox(height: 6),
          Text(caption, style: TextStyle(fontSize: 13, color: foregroundColor))
        ]
      ),
      color: color,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        _action(
          icon: FeatherIcons.archive,
          caption: '归档',
          color: GsColors.of(context).background,
          foregroundColor: GsColors.of(context).primary,
          onTap: () {
            Future.delayed(Duration.zero, () async {
              final habitStore = Provider.of<HabitStore>(context, listen: false);
              value.isArchived = true;
              habitStore.save(value);
            });
          },
        ),
      ],
      secondaryActions: <Widget>[
        _action(
          icon: FeatherIcons.trash_2,
          caption: '删除',
          color: GsColors.of(context).background,
          foregroundColor: GsColors.of(context).red,
          onTap: () => GsHelper.of(context).alertDialog(
            title: Text('您确定要删除吗？'),
            content: Text('将删除此习惯的所有数据，不可恢复。'),
            actions: [
              AlertDialogActionModel(
                content: Text('确定', style: TextStyle(color: GsColors.of(context).red)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Future.delayed(Duration.zero, () async {
                    final habitStore = Provider.of<HabitStore>(context, listen: false);
                    habitStore.remove(value);
                  });
                },
              ),
              AlertDialogActionModel(
                content: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: GestureDetector(
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
        ),
      ),
    );
  }
}