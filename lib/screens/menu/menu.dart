import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/icons/icons.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({
    Key key,
    @required this.routeName,
  }) : super(key: key);

  final String routeName;

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _item(IconData iconData, String name, String title, {
    bool more = false,
  }) {
    final selected = name == widget.routeName;
    final color = selected ? Colors.white : CupertinoColors.label.withOpacity(more ? 0.6 : 1);
    final backgroundColor = selected ? GsColors.of(context).primary : Colors.transparent;
    return InkWell(
      child: Ink(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: backgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(iconData, size: 20, color: color),
            SizedBox(width: 15),
            Text(title, style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
          ],
        ),  
      ),
      onTap: () {
        Constant.emitter.emit('drawer@selected', {
          'routeName': name
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _item(FeatherIcons.layout, '/', '习惯'),
            _item(FeatherIcons.calendar, '/calendar', '日历'),
            _item(FeatherIcons.activity, '/count', '统计'),
            _item(FeatherIcons.archive, '/trash', '已归档'),
            Divider(height: 30, indent: 10, endIndent: 10, color: Color(0xFFD2D2D4)),
            _item(FeatherIcons.book, '/guide', '指南', more: true),
            _item(FeatherIcons.settings, '/setting', '设置', more: true),
          ],
        ),
      ),
    );
  }
}
