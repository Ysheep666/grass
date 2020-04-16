import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class _PopupModal extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const _PopupModal({Key key, this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      clipBehavior: Clip.antiAlias,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: child,
    );
  }
}

Future<T> showPopup<T>({
  @required BuildContext context,
  @required ScrollWidgetBuilder builder,
  Color backgroundColor,
}) async {
  final result = await showCustomModalBottomSheet(
    context: context,
    builder: builder,
    containerWidget: (_, animation, child) => _PopupModal(child: child),
    expand: false,
  );
  return result;
}
