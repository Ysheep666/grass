import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/cell/check_cell.dart';
import 'package:grass/widgets/cell/text_field_cell.dart';

class RepeatStatusPicker extends StatefulWidget {
  RepeatStatusPicker({
    Key key,
    this.statusType,
    this.statusValues,
    this.onChanged,
  }) : super(key: key);

  final int statusType;
  final List<int> statusValues;
  final ValueChanged<Map> onChanged;

  @override
  _RepeatStatusPickerState createState() => _RepeatStatusPickerState();
}

class _RepeatStatusPickerState extends State<RepeatStatusPicker> {
  final Map<int, Widget> segmentedChildren = const {
    0: Text('每日'),
    1: Text('每周'),
    2: Text('自定义'),
  };

  TextEditingController _valueController;

  int _type;
  Map<int, List<int>> _values = {
    0: Constant.weekDays.asMap().keys.toList(),
    1: [0],
    2: [2],
  };

  @override
  void initState() {
    _type = widget.statusType;
    _values[widget.statusType] = widget.statusValues;
    _valueController = TextEditingController(text: '${_values[2][0]}');
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.onChanged({
      'type': _type,
      'values': _values[_type],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GsColors.of(context).background,
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 11 / 16,
        child: Scaffold(
          backgroundColor: GsColors.of(context).background,
          appBar: GsAppBar(
            padding: EdgeInsetsDirectional.only(start: 5, end: 5),
            middle: Text('重复'),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.clear, size: 28, color: GsColors.of(context).text),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView(
            children: _items(),
          ),
        ),
      ),
    );
  }

  List<Widget> _items() {
    final items = <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: CupertinoSlidingSegmentedControl(
          children: segmentedChildren,
          onValueChanged: (int newValue) {
            setState(() {
              _type = newValue;
            });
          },
          groupValue: _type,
        ),
      )
    ];

    switch (_type) {
      case 0:
        items.addAll(
          Constant.weekDays.asMap().map((i, title) => MapEntry(
            i,
            CheckCell(
              title: title, 
              checked: _values[0].contains(i),
              onTap: () {
                setState(() {
                  if (_values[0].contains(i)) {
                    _values[0].remove(i);
                  } else {
                    _values[0].add(i);
                  }
                });
              },
            ),
          )).values.toList(),
        );
        break;
      case 1:
        items.addAll(
          List(7).asMap().map((i, title) => MapEntry(
            i,
            CheckCell(
              title: '每周第 ${i + 1} 天',
              checked: _values[1].contains(i),
              onTap: () {
                setState(() {
                  _values[1] = [i];
                });
              },
            ),
          )).values.toList(),
        );
        break;
      case 2:
        items.add(
          TextFieldCell(
            title: '间隔天数',
            hintText: '请输入间隔天数',
            controller: _valueController,
            textInputAction: TextInputAction.done,
          ),
        );
        break;
      default:
    }
    return items;
  }
}
