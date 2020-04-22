import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/bridge/native_widget.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/utils/mixin/route_observer_mixin.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/custom_keyboard/custom_keyboard.dart';
import 'package:provider/provider.dart';

import 'motion_record_list.dart';
import 'top.dart';
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
  final GlobalKey<GsCustomKeyboardState> _keyboardKey = GlobalKey<GsCustomKeyboardState>();
  HabitDetailStore _habitDetailStore;
  bool _isSubmit = false;
  bool _isShowKeyboard = false;
  bool _appBarShadow = false;
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    Constant.emitter.on('habit_detail@show_keyboard', _showKeyboard);
    Constant.emitter.on('habit_detail@hide_keyboard', _hideKeyboard);
    Future.delayed(Duration.zero, () async {
      _habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
      await _habitDetailStore.didLoad(widget.habit);
    });
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

  _showKeyboard(data) {
    final focusNode = data['focusNode'] as FocusNode;
    final textEditingController = data['textEditingController'] as TextEditingController;
    if (_overlayEntry == null) {
      _insertOverlay(focusNode, textEditingController);
    } else {
      _keyboardKey.currentState?.focusNode = focusNode;
      _keyboardKey.currentState?.textEditingController = textEditingController;
      if (!_isShowKeyboard) {
        _keyboardKey.currentState?.open();
      }
    }
    setState(() {
      _isShowKeyboard = true;
    });
  }

  _hideKeyboard(data) {
    FocusScope.of(context).unfocus();
    if (_isShowKeyboard) {
      _keyboardKey.currentState?.dismiss();
      setState(() {
        _isShowKeyboard = false;
      });
    }
  }

  void _insertOverlay(FocusNode focusNode, TextEditingController textEditingController) {
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

  void _removeOverlay() async {
    await Future.delayed(Duration(milliseconds: 500));
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        final habitDetailStore = Provider.of<HabitDetailStore>(context);
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
                  color: _isSubmit ? CupertinoColors.white : CupertinoDynamicColor.resolve(GsColors.grey, context),
                ),
              ),
              onPressed: _isSubmit ? () async {
              } : null,
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
                child: Padding(
                  padding: EdgeInsets.only(bottom: _isShowKeyboard ?  GsCustomKeyboard.preferredHeight : 0),
                  child: CustomScrollView(
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
                                  _hideKeyboard(null);
                                  final ids = await NativeWidget.motionPicker();
                                  habitDetailStore.addMotionsByIds(ids);
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
}
