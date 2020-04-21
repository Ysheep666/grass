import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GsSideMenu extends StatefulWidget {
  GsSideMenu({
    Key key,
    @required this.menu,
    @required this.content,
    this.menuWidth = 200,
    this.maskColor,
    this.maskOpacity = 0.1,
  }) : super(key: key);

  final Widget menu;
  final Widget content;

  final double menuWidth;
  final Color maskColor;
  final double maskOpacity;

  @override
  GsSideMenuState createState() => GsSideMenuState();
}

class GsSideMenuState extends State<GsSideMenu> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _previouslyOpened = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      value: 0,
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

  void open() {
    _animationController.fling(velocity: 1);
  }

  void close() {
    _animationController.fling(velocity: -1);
  }

  void toggle() {
    if (_previouslyOpened) {
      _animationController.fling(velocity: -1);
    } else {
      _animationController.fling(velocity: 1);
    }
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
        Transform.translate(
          offset: Offset(widget.menuWidth *  _animationController.value, 0),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              widget.content,
              IgnorePointer(
                ignoring: !_previouslyOpened,
                child: GestureDetector(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Opacity(
                        opacity: widget.maskOpacity * _animationController.value,
                        child: Container(
                          color: widget.maskColor ?? CupertinoDynamicColor.resolve(
                            CupertinoDynamicColor.withBrightness(
                              color: Colors.black,
                              darkColor: Colors.white,
                            ),
                            context,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () => close()
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(widget.menuWidth * (_animationController.value - 1), 0),
          child: Container(
            width: widget.menuWidth,
            child: widget.menu
          )
        ),
      ],
    );
  }
}
