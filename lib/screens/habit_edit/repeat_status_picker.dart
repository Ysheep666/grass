import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grass/models/habit.dart';
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

  final HabitRepeatStatusType statusType;
  final List<int> statusValues;
  final ValueChanged<Map> onChanged;

  @override
  _RepeatStatusPickerState createState() => _RepeatStatusPickerState();
}

class _RepeatStatusPickerState extends State<RepeatStatusPicker> {
  final Map<HabitRepeatStatusType, Widget> segmentedChildren = const {
    HabitRepeatStatusType.day: Text('每日'),
    HabitRepeatStatusType.week: Text('每周'),
    HabitRepeatStatusType.custom: Text('自定义'),
  };

  FocusNode _valueFocusNode;
  TextEditingController _valueController;

  HabitRepeatStatusType _type;
  Map<HabitRepeatStatusType, List<int>> _values = {
    HabitRepeatStatusType.day: Constant.weekDays.asMap().keys.toList(),
    HabitRepeatStatusType.week: [0],
    HabitRepeatStatusType.custom: [2],
  };

  @override
  void initState() {
    super.initState();
    _type = widget.statusType;
    _values[widget.statusType] = widget.statusValues;
    _valueFocusNode = FocusNode();
    _valueController = TextEditingController(text: '${_values[HabitRepeatStatusType.custom][0]}');

    _valueFocusNode.addListener(() {
      if(_valueFocusNode.hasFocus) {
        _valueController.selection = TextSelection(baseOffset: 0, extentOffset: _valueController.text.length);
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.onChanged({
      'type': _type,
      'values': _type == HabitRepeatStatusType.custom ? 
          [_valueController.text == '' ? 0 : int.parse(_valueController.text)] : _values[_type],
    });
  }

  @override
  void dispose() {
    _valueFocusNode.dispose();
    super.dispose();
  }

  List<Widget> _items() {
    final items = <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: CupertinoSlidingSegmentedControl(
          children: segmentedChildren,
          onValueChanged: (HabitRepeatStatusType newValue) {
            HapticFeedback.selectionClick();
            setState(() {
              _type = newValue;
            });
          },
          groupValue: _type,
        ),
      )
    ];

    switch (_type) {
      case HabitRepeatStatusType.day:
        items.addAll(
          Constant.weekDays.asMap().map((i, title) => MapEntry(
            i,
            CheckCell(
              title: title, 
              checked: _values[HabitRepeatStatusType.day].contains(i),
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (_values[HabitRepeatStatusType.day].contains(i)) {
                    _values[HabitRepeatStatusType.day].remove(i);
                  } else {
                    _values[HabitRepeatStatusType.day].add(i);
                  }
                });
              },
            ),
          )).values.toList(),
        );
        break;
      case HabitRepeatStatusType.week:
        items.addAll(
          List(7).asMap().map((i, title) => MapEntry(
            i,
            CheckCell(
              title: '每周第 ${i + 1} 天',
              checked: _values[HabitRepeatStatusType.week].contains(i),
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _values[HabitRepeatStatusType.week] = [i];
                });
              },
            ),
          )).values.toList(),
        );
        break;
      case HabitRepeatStatusType.custom:
        items.add(
          TextFieldCell(
            title: '间隔天数',
            hintText: '请输入间隔天数',
            focusNode: _valueFocusNode,
            controller: _valueController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
          ),
        );
        break;
      default:
    }
    return items;
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
}
