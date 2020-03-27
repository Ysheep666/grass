import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';

class SwitchCell extends StatelessWidget {
  const SwitchCell({
    Key key,
    this.onChanged,
    @required this.title,
    this.checked = false,
    this.border,
  }): super(key: key);

  final ValueChanged<bool> onChanged;
  final String title;
  final bool checked;
  final Border border;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 15),
        padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            border: border ?? Border(
              bottom: Divider.createBorderSide(context, width: 0.6),
            )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(title, style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: GsColors.of(context).text,
            )),
            Spacer(),
            SizedBox(width: 15),
            CupertinoSwitch(
              value: checked,
              onChanged: onChanged,
            ),
          ],
        ),
      );
  }
}
