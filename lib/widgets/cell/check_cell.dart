import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/widgets/icons/icons.dart';

class CheckCell extends StatelessWidget {
  const CheckCell({
    Key key,
    this.onTap,
    @required this.title,
    this.checked = false,
  }): super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
        constraints: BoxConstraints(
          maxHeight: double.infinity,
          minHeight: 50
        ),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
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
            Opacity(
              opacity: checked ? 1 : 0,
              child: Icon(FeatherIcons.check, color: GsColors.of(context).primary),
            )
          ],
        ),
      ),
    );
  }
}