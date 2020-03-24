
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/widgets/icons/icons.dart';

class Cell extends StatelessWidget {
  const Cell({
    Key key,
    this.onTap,
    @required this.title,
    this.content: '',
    this.textAlign: TextAlign.start,
    this.maxLines: 1
  }): super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final int maxLines;

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
          crossAxisAlignment: maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(
              fontSize: 15,
              color: GsColors.of(context).text,
            )),
            Spacer(),
            SizedBox(width: 15),
            Expanded(
              flex: 4,
              child: Text(
                content,
                maxLines: maxLines,
                textAlign: maxLines == 1 ? TextAlign.right : textAlign,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: GsColors.of(context).gray,
                ),
              ),
            ),
            SizedBox(width: 10),
            Opacity(
              opacity: onTap == null ? 0 : 1,
              child: Padding(
                padding: EdgeInsets.only(top: maxLines == 1 ? 0 : 2),
                child: Icon(FeatherIcons.chevron_right, color: GsColors.of(context).gray),
              ),
            )
          ],
        ),
      ),
    );
  }
}
