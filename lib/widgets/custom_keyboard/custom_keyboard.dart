import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _keyButtonSpacing = 6;
const double _keyButtonSize = 48;
const Duration _defaultSideMenuDuration = Duration(milliseconds: 250);

class GsCustomKeyboard extends StatefulWidget {
  GsCustomKeyboard({
    Key key,
    @required this.child,
    this.duration = _defaultSideMenuDuration,
  }) : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  GsCustomKeyboardState createState() => GsCustomKeyboardState();
}

class GsCustomKeyboardState extends State<GsCustomKeyboard> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  TextEditingController _textEditingController;
  bool _previouslyOpened = false;

  double get preferredHeight {
    final data = MediaQueryData.fromWindow(window);
    return 4 * _keyButtonSize + 5 * _keyButtonSpacing + data.padding.bottom;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      value: 0,
      duration: widget.duration,
      vsync: this
    )
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void open(TextEditingController controller) {
    _textEditingController = controller;
    _animationController.fling(velocity: 1);
  }

  void close() {
    _animationController.fling(velocity: -1);
  }

  void _animationChanged() {
    setState(() {});
  }

  void _animationStatusChanged(AnimationStatus status) {
    final bool opened = _animationController.value > 0 ? true : false;
    switch (status) {
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.dismissed:
        if (_previouslyOpened != opened) {
          _previouslyOpened = opened;
        }
        break;
      case AnimationStatus.completed:
        if (_previouslyOpened != opened) {
          _previouslyOpened = opened;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(0, preferredHeight * (1 - _animationController.value)),
            child: Container(
              height: preferredHeight,
              color: CupertinoColors.systemGrey4,
              child: Center(
                child: CupertinoButton(
                  child: Text('click'),
                  onPressed: () {
                    final value = 'x';
                    final selection = _textEditingController.selection;
                    final splitText = _textEditingController.text.split('').toList();
                    if (selection.start == selection.end) {
                      splitText.insert(selection.start, value);
                    } else {
                      splitText.replaceRange(selection.start, selection.end, [value]);
                    }
                    _textEditingController.value = TextEditingValue(
                      text: splitText.join(''),
                      selection: TextSelection.collapsed(offset: selection.start + 1)
                    );
                  }
                ),
              )
            )
          ),
        ),
      ],
    );
  }
}
