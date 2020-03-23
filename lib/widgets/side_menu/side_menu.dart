import 'package:flutter/material.dart';

const Duration _kBaseSettleDuration = Duration(milliseconds: 120);

class GrassSideMenu extends StatefulWidget {
  GrassSideMenu({
    Key key,
    @required this.menu,
    @required this.content,
    this.menuWidth = 200,
    this.duration = _kBaseSettleDuration,
  }) : super(key: key);

  final Widget menu;
  final Widget content;

  final double menuWidth;
  final Duration duration;

  @override
  GrassSideMenuState createState() => GrassSideMenuState();
}

class GrassSideMenuState extends State<GrassSideMenu> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _previouslyOpened = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: 0,
      duration: widget.duration,
      vsync: this
    )
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void open() {
    _controller.fling(velocity: 1);
  }

  void close() {
    _controller.fling(velocity: -1);
  }

  void toggle() {
    if (_previouslyOpened) {
      _controller.fling(velocity: -1);
    } else {
      _controller.fling(velocity: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(widget.menuWidth *  _controller.value, 0),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              widget.content,
              IgnorePointer(
                ignoring: !_previouslyOpened,
                child: GestureDetector(
                  child: Container(
                    color: Colors.black.withOpacity(0.15 * _controller.value),
                  ),
                  onTap: () => close()
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(widget.menuWidth * (_controller.value - 1), 0),
          child: Container(
            width: widget.menuWidth,
            child: widget.menu
          )
        ),
      ],
    );
  }


  void _animationChanged() {
    setState(() {});
  }

  void _animationStatusChanged(AnimationStatus status) {
    final bool opened = _controller.value > 0 ? true : false;
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
}
