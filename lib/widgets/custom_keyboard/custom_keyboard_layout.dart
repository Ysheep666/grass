import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_keyboard.dart';

class GsCustomKeyboardLayout extends StatefulWidget {
  GsCustomKeyboardLayout({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  GsCustomKeyboardLayoutState createState() => GsCustomKeyboardLayoutState();
}

class GsCustomKeyboardLayoutState extends State<GsCustomKeyboardLayout> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  VoidCallback _callback;

  @override
  void initState() {
    _animationController =
      AnimationController(value: 0, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _callback();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  open() async {
    final c = Completer();
    _callback = c.complete;
    _animationController.fling(velocity: 1);
    return c.future;
  }

  dismiss() {
    _animationController.fling(velocity: -1);
  }

  @override
  Widget build(BuildContext context) {
    final animation =
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(0, 0, 0, 0),
        end: RelativeRect.fromLTRB(0, 0, 0, GsCustomKeyboard.preferredHeight),
      )
      .animate(_animationController);

    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: animation,
          builder: (context, snapshot) {
            return PositionedTransition(
              rect: animation,
              child: widget.child,
            );
          }
        ),
      ],
    );
  }
}