import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';

class GsAppBar extends StatelessWidget implements PreferredSizeWidget {
  GsAppBar({
    Key key,
    this.middle,
    this.leading,
    this.trailing,
    this.backgroundColor,
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
    final _backgroundColor = backgroundColor ?? GsColors.of(context).background;
    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor,
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
        backgroundColor: _backgroundColor,
        middle: DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(fontWeight: FontWeight.w400),
          child: middle,
        ),
        leading: leading,
        trailing: trailing,
        border: Border.all(width: 0, color: _backgroundColor),
      ),
    );
  }
}
