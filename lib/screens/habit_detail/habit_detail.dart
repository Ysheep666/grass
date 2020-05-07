import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/models/motion_record.dart';
import 'package:grass/screens/result/habit_good_result.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/bridge/native_widget.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/utils/mixin/route_observer_mixin.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/custom_keyboard/custom_keyboard.dart';
import 'package:grass/widgets/custom_keyboard/custom_keyboard_layout.dart';
import 'package:provider/provider.dart';

import 'motion_record_list.dart';
import 'top.dart';

enum HabitDetailItemSwitchType {
  up,
  down,
}

class HabitDetailItemSwitchData {
  final HabitDetailItemSwitchType type;
  final MotionRecord motionRecord;
  HabitDetailItemSwitchData({this.type, this.motionRecord});
}

class HabitDetailScreen extends StatefulWidget {
  HabitDetailScreen({
    Key key,
    @required this.habit,
  }) : super(key: key);

  final Habit habit;

  @override
  HabitDetailScreenState createState() => HabitDetailScreenState();
}

class HabitDetailScreenState extends State<HabitDetailScreen> with RouteAware, RouteObserverMixin {
  final _keyboardKey = GlobalKey<GsCustomKeyboardState>();
  final _keyboardLayoutKey = GlobalKey<GsCustomKeyboardLayoutState>();
  final _scrollController = ScrollController();

  HabitDetailStore _habitDetailStore;

  bool _isShowKeyboard = false;
  bool _appBarShadow = false;
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    Constant.emitter.on('habit_detail@show_keyboard', _showKeyboard);
    Constant.emitter.on('habit_detail@hide_keyboard', _hideKeyboard);
    super.initState();
  }

  @override
  void deactivate() {
    Future.delayed(Duration.zero, () async {
      _habitDetailStore?.clear();
      _habitDetailStore = null;
    });
    super.deactivate();
  }

  @override
  void dispose() {
    Constant.emitter.off('habit_detail@show_keyboard', _showKeyboard);
    Constant.emitter.off('habit_detail@hide_keyboard', _hideKeyboard);
    _removeOverlay();
    super.dispose();
  }

  @override
  void didPop() {
    _hideKeyboard(null);
  }

  _didLoad() async {
    _habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
    if (!_habitDetailStore.isLoaded) {
      await _habitDetailStore.didLoad(widget.habit);
      Future.delayed(Duration(milliseconds: 100), () async {
        if (_habitDetailStore.isContinue && _habitDetailStore.motionGroupRecords.indexWhere((c) => !c.isDone) != -1) {
          final result = await NativeWidget.alert(
            title: '继续锻炼？',
            message: '您有未完成的锻炼，确定继续锻炼。',
            actions: [
              AlertAction(value: 'reset', title: '重新开始'),
              AlertAction(value: 'ok', title: '确定'),
            ]
          );
          if (result == 'reset') {
            await _habitDetailStore.reset();
          }
        }
      });
    }
  }

  _showKeyboard(data) async {
    final focusNode = data['focusNode'] as FocusNode;
    final textEditingController = data['textEditingController'] as GsCustomKeyboardController;
    if (_overlayEntry == null) {
      _insertOverlay(focusNode, textEditingController);
    } else {
      _keyboardKey.currentState?.focusNode = focusNode;
      _keyboardKey.currentState?.textEditingController = textEditingController;
      if (!_isShowKeyboard) {
        _keyboardKey.currentState?.open();
      }
    }

    if (!_isShowKeyboard) {
      await _keyboardLayoutKey.currentState.open();
      setState(() {
        _isShowKeyboard = true;
      });

      Future.delayed(Duration.zero, () {
        RenderBox object = focusNode.context.findRenderObject();
        final mediaQueryData = MediaQueryData.fromWindow(window);
        final focusOffset = object.localToGlobal(Offset.zero);
        final bottom = mediaQueryData.size.height - focusOffset.dy;
        if (bottom < GsCustomKeyboard.preferredHeight + 20) {
          Scrollable.ensureVisible(
            focusNode.context,
            duration: Duration(milliseconds: 120),
            alignment: 0.96,
          );
        }
      });
    }
  }

  _hideKeyboard(data) {
    FocusScope.of(context).unfocus();
    if (_isShowKeyboard) {
      _keyboardKey.currentState?.dismiss();
      _keyboardLayoutKey.currentState.dismiss();
      setState(() {
        _isShowKeyboard = false;
      });
    }
  }

  _insertOverlay(FocusNode focusNode, GsCustomKeyboardController textEditingController) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: GsCustomKeyboard(
            key: _keyboardKey,
            focusNode: focusNode,
            textEditingController: textEditingController,
            onHide: () {
              _hideKeyboard(null);
            },
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry);
  }

  _removeOverlay() async {
    await Future.delayed(Duration(milliseconds: 500));
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  _submit() async {
    Constant.emitter.emit('habit_detail@hide_keyboard');
    Constant.emitter.emit('habit_detail@close_slidable');
    bool continueSubmit = false;
    final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
    if (habitDetailStore.motionGroupRecords.indexWhere((c) => !c.isDone) != -1) {
      final result = await NativeWidget.alert(
        title: '确认完成锻炼？',
        message: '如果确定，所有无效或无内容的组将被删除，有效的组都将被标记为已完成。',
        actions: [
          AlertAction(value: 'ok', title: '确定'),
          AlertAction(value: 'cancel', title: '取消', style: AlertActionStyle.cancel),
        ]
      );
      continueSubmit = result == 'ok';
    } else {
      continueSubmit = true;
    }
    if (continueSubmit) {
      await habitDetailStore.submit();
      NativeMethod.notificationFeedback(NotificationFeedbackType.success);
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => HabitGoodResultScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _didLoad(),
      builder: (context, snapshot) {
        return Observer(
          builder: (BuildContext context) {
            final habitDetailStore = Provider.of<HabitDetailStore>(context);
            final isSubmit = habitDetailStore.motionGroupRecords.indexWhere((c) => c.isDone) != -1;
            return Scaffold(
              backgroundColor: CupertinoDynamicColor.resolve(GsColors.background, context),
              appBar: GsAppBar(
                decoration: BoxDecoration(
                  boxShadow: _appBarShadow ? null : [],
                ),
                middle: Center(),
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text('取消', style: CupertinoTheme.of(context).textTheme.actionTextStyle),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                ),
                trailing: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  color: CupertinoDynamicColor.resolve(GsColors.green, context),
                  minSize: 0,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Text(
                    '完成训练',
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontSize: 14,
                      color: isSubmit ? CupertinoColors.white : CupertinoDynamicColor.resolve(GsColors.grey, context),
                    ),
                  ),
                  onPressed: isSubmit ? _submit : null,
                ),
              ),
              body: habitDetailStore.isLoaded 
                  ? NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      final shadow = notification.metrics.pixels > 0;
                      if (_appBarShadow != shadow) {
                        setState(() {
                          _appBarShadow = shadow;
                        });
                      }
                      return true;
                    },
                    child: GsCustomKeyboardLayout(
                      key: _keyboardLayoutKey,
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Top(habit: habitDetailStore.habit),
                          ),
                          habitDetailStore.isLoaded ? MotionRecordList() : Center(),
                          SliverToBoxAdapter(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    color: CupertinoDynamicColor.resolve(GsColors.primary, context),
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    minSize: 0,
                                    child: Text(
                                      '添加动作',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: CupertinoColors.white,
                                      ),
                                    ),
                                    onPressed: () async {
                                      Constant.emitter.emit('habit_detail@hide_keyboard');
                                      Constant.emitter.emit('habit_detail@close_slidable');
                                      final ids = await NativeWidget.motionPicker();
                                      habitDetailStore.addMotionRecordsByMotionIds(ids);
                                    },
                                  ),
                                ),
                                SizedBox(height: _isShowKeyboard ? 0 : MediaQuery.of(context).padding.bottom),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : Center(),
            );
          },
        );
      }
    );
  }
}
