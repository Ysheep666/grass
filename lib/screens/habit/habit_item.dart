import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/screens/habit_detail/habit_detail.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/bridge/native_widget.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';

class HabitItem extends StatelessWidget {
  const HabitItem({
    Key key,
    this.habit,
    this.slidableController,
  }) : super(key: key);

  final Habit habit;
  final SlidableController slidableController;

  SlideAction _action({IconData icon, String caption, Color color, Color foregroundColor, VoidCallback onTap}) {
    return SlideAction(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 20, color: foregroundColor),
          SizedBox(height: 6),
          Text(caption, style: TextStyle(fontSize: 13, color: foregroundColor)),
        ],
      ),
      color: color,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: slidableController,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        _action(
          icon: FeatherIcons.archive,
          caption: '归档',
          color: CupertinoDynamicColor.resolve(GsColors.background, context),
          foregroundColor: GsColors.primary,
          onTap: () {
            Future.delayed(Duration.zero, () async {
              final habitStore = Provider.of<HabitStore>(context, listen: false);
              habit.isArchived = true;
              habitStore.save(habit);
            });
          },
        ),
      ],
      secondaryActions: <Widget>[
        _action(
          icon: FeatherIcons.trash_2,
          caption: '删除',
          color: CupertinoDynamicColor.resolve(GsColors.background, context),
          foregroundColor: GsColors.red,
          onTap: () async {
            final result = await NativeWidget.alert(
              title: '您确定要删除吗？',
              message: '将删除此习惯的所有数据，不可恢复。',
              actions: [
                AlertAction(value: 'ok', title: '确定', style: AlertActionStyle.destructive),
                AlertAction(value: 'cancel', title: '取消', style: AlertActionStyle.cancel),
              ]
            );
            if (result == 'ok') {
              Future.delayed(Duration.zero, () async {
                final habitStore = Provider.of<HabitStore>(context, listen: false);
                habitStore.remove(habit);
                NativeWidget.toast('✌️删除成功✌️');
              });
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoDynamicColor.resolve(GsColors.boxBackground, context),
              boxShadow: [
                BoxShadow(
                  color: CupertinoDynamicColor.resolve(GsColors.shadowColor, context),
                  offset: Offset(0, 1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          habit.name, 
                          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 21),
                        ),
                      ),
                      Text(
                        '已完成次数',
                        style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                          fontSize: 12,
                          color: CupertinoDynamicColor.resolve(GsColors.grey, context)
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          habit.remarks.isEmpty ? '暂无备注' : habit.remarks,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            fontSize: 15,
                            color: CupertinoDynamicColor.resolve(GsColors.grey, context),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '0',
                          textAlign: TextAlign.right, 
                          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            Constant.emitter.emit('habit@close_slidable');
            NativeMethod.impactFeedback(ImpactFeedbackStyle.light);
            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => HabitDetailScreen(habit: habit)
              ),
            );
          },
        ),
      ),
    );
  }
}