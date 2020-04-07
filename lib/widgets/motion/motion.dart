import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';

class MotionList extends StatefulWidget {
  const MotionList({Key key}) : super(key: key);

  @override
  _MotionListState createState() => _MotionListState();
}

class _MotionListState extends State<MotionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GsAppBar(
        shadow: false,
        padding: EdgeInsetsDirectional.only(start: 5, end: 5),
        middle: Text('运动'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.clear, size: 36, color: GsColors.of(context).text),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          
        ],
      ),
    );
  }
}
