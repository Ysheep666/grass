import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grass/utils/colors.dart';

import 'bottom_sheet.dart';

class _PopupModal extends StatelessWidget {
  const _PopupModal({
    Key key,
    this.child,
    this.backgroundColor,
    this.onWillPop,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;
  final WillPopCallback onWillPop;

  @override
  Widget build(BuildContext context) {
    final content = Material(
      color: backgroundColor,
      shadowColor: CupertinoDynamicColor.resolve(
        CupertinoDynamicColor.withBrightness(
          color: Colors.black,
          darkColor: Colors.white,
        ),
        context,
      ),
      clipBehavior: Clip.antiAlias,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: child
      ),
    );

    if (onWillPop == null) {
      return content;
    }

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: content,
    );
  }
}

Future<T> showPopup<T>({
  @required BuildContext context,
  @required ScrollWidgetBuilder builder,
  Color backgroundColor,
  WillPopCallback onWillPop,
}) async {
  final result = await showCustomModalBottomSheet(
    context: context,
    builder: builder,
    containerWidget: (_, animation, child) => _PopupModal(
      child: child,
      backgroundColor: backgroundColor ?? CupertinoDynamicColor.resolve(GsColors.boxBackground, context),
      onWillPop: onWillPop,
    ),
    expand: false,
    useRootNavigator: true,
  );
  return result;
}
