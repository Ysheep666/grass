import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GrassAppBar extends StatelessWidget implements PreferredSizeWidget {
  GrassAppBar({
    Key key,
    this.middle,
    this.leading,
    this.trailing,
    this.backgroundColor = Colors.white,
    this.shadow = true,
  })  : preferredSize = Size.fromHeight(44),
        super(key: key);

  final Widget middle;
  final Widget leading;
  final Widget trailing;
  final Color backgroundColor;
  final bool shadow;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: shadow ? [
            BoxShadow(
              color: Color(0xFF222122).withOpacity(0.1),
              offset: Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
            )
          ] : [],
      ),
      child: CupertinoNavigationBar(
        backgroundColor: backgroundColor,
        middle: middle,
        leading: leading,
        trailing: trailing,
        border: Border.all(width: 0, color: backgroundColor),
      ),
    );
  }
}
