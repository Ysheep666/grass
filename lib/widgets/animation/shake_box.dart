import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShakeBox extends StatefulWidget {
  ShakeBox({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  ShakeBoxState createState() => ShakeBoxState();
}

class ShakeBoxState extends State<ShakeBox> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(duration: const Duration(milliseconds: 120), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  start() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation =
      TweenSequence([
        TweenSequenceItem<double>(tween: Tween(begin: 0, end: 5), weight: 1),
        TweenSequenceItem<double>(tween: Tween(begin: 5, end: 0), weight: 2),
        TweenSequenceItem<double>(tween: Tween(begin: 0, end: -5), weight: 3),
        TweenSequenceItem<double>(tween: Tween(begin: -5, end: 0), weight: 4),
        TweenSequenceItem<double>(tween: Tween(begin: 0, end: 5), weight: 5),
      ])
      .animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });

    return AnimatedBuilder(
      animation: animation,
      builder: (context, snapshot) {
        return Transform.translate(
          offset: Offset(animation.value, 0),
          child: widget.child,
        );
      }
    );
  }
}