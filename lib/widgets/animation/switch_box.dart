import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchBox extends StatefulWidget {
  SwitchBox({
    Key key,
    @required this.start,
    @required this.end,
    @required this.child,
    this.autoStart = false,
    this.completed,
  }) : super(key: key);

  final Offset start;
  final Offset end;
  final Widget child;
  final bool autoStart;
  final VoidCallback completed;

  @override
  SwitchBoxState createState() => SwitchBoxState();
}

class SwitchBoxState extends State<SwitchBox> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(value: 0, vsync: this);
    if (widget.autoStart) {
      start();
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  start() {
    _animationController.fling(velocity: 1);
  }

  @override
  Widget build(BuildContext context) {
    final animation =
      Tween(begin: 0.0, end: 1.0)
      .animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget?.completed();
        }
      });
    final dx = widget.end.dx - widget.start.dx;
    final dy = widget.end.dy - widget.start.dy;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, snapshot) {
        return Transform.translate(
          offset: Offset(widget.start.dx + animation.value * dx, widget.start.dy + animation.value * dy),
          child: widget.child,
        );
      }
    );
  }
}