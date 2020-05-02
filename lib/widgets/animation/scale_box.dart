import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScaleBox extends StatefulWidget {
  ScaleBox({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  ScaleBoxState createState() => ScaleBoxState();
}

class ScaleBoxState extends State<ScaleBox> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = 
      AnimationController(duration: const Duration(milliseconds: 120), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });
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
    final animation =
      Tween(begin: 0.0, end: 5.0)
      .animate(_animationController);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, snapshot) {
        return Transform.scale(
          scale: (1 + animation.value * 0.01),
          child: widget.child,
        );
      }
    );
  }
}