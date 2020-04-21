import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  const Cell({
    Key key,
    this.onTap,
    @required this.title,
    this.content: '',
    this.textAlign: TextAlign.start,
    this.maxLines: 1,
    this.border,
  }): super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final int maxLines;
  final Border border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            border: border ?? Border(
              bottom: Divider.createBorderSide(context, width: 0.6),
            )
        ),
        child: Row(
          crossAxisAlignment: maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
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
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 15,
                  color: CupertinoDynamicColor.resolve(CupertinoColors.secondaryLabel, context),
                ),
              ),
            ),
            SizedBox(width: 3),
            Opacity(
              opacity: onTap == null ? 0 : 1,
              child: Padding(
                padding: EdgeInsets.only(top: maxLines == 1 ? 0 : 2),
                child: Icon(
                  CupertinoIcons.right_chevron, 
                  color: CupertinoDynamicColor.resolve(CupertinoColors.tertiaryLabel, context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
