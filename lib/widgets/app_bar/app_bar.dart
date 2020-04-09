import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';

class GsAppBar extends StatelessWidget implements PreferredSizeWidget {
  GsAppBar({
    Key key,
    this.middle,
    this.leading,
    this.trailing,
    this.padding,
    this.backgroundColor,
    this.shadow = true,
  })  : preferredSize = Size.fromHeight(44),
        super(key: key);

  final Widget middle;
  final Widget leading;
  final Widget trailing;
  final EdgeInsetsDirectional padding;
  final Color backgroundColor;
  final bool shadow;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final _backgroundColor = backgroundColor ?? CupertinoColors.systemBackground;
    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor,
          boxShadow: shadow ? [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.3),
              offset: Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
            )
          ] : [],
      ),
      child: CupertinoNavigationBar(
        padding: padding,
        backgroundColor: _backgroundColor,
        middle: DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          child: middle,
        ),
        leading: leading,
        trailing: trailing,
        border: Border.all(width: 0, color: _backgroundColor),
      ),
    );
  }
}
