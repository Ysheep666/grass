import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/screens/scheme_add/scheme_add.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';

class SchemeListScreen extends StatefulWidget {
  SchemeListScreen({Key key}) : super(key: key);

  @override
  _SchemeListScreenState createState() => _SchemeListScreenState();
}

class _SchemeListScreenState extends State<SchemeListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GrassAppBar(
        middle: Text('健身小助手'),
        shadow: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            MaterialButton(
                child: Text('drawer@toggle'),
                onPressed: () {
                  Constant.emitter.emit('drawer@toggle');
                }),
            MaterialButton(
                child: Text('push next page'),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      // fullscreenDialog: true,
                      builder: (context) => SchemeAddScreen()
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
