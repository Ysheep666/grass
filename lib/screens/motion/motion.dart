import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/search_bar/search_bar.dart';

class MotionScreen extends StatefulWidget {
  const MotionScreen({Key key}) : super(key: key);

  @override
  _MotionScreenState createState() => _MotionScreenState();
}

class _MotionScreenState extends State<MotionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GsColors.of(context).background,
      appBar: GsAppBar(
        shadow: false,
        padding: const EdgeInsetsDirectional.only(start: 5, end: 5),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GsSearchBar(

          ),
          Expanded(
            child: Text('1'),
          ),
        ],
      ),
    );
  }
}
