import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/cell/cell.dart';
import 'package:grass/widgets/cell/text_field_cell.dart';

import 'repeat_status_picker.dart';

class HabitEditScreen extends StatefulWidget {
  HabitEditScreen({
    Key key,
    @required this.habit,
  }) : super(key: key);

  final Habit habit;

  @override
  HabitEditScreenState createState() => HabitEditScreenState();
}

class HabitEditScreenState extends State<HabitEditScreen> {
  FocusNode _nameFocusNode;
  TextEditingController _nameController;
  TextEditingController _remarksController;

  Habit _value;
  bool _isSubmit = false;

  String get _repeatLabel {
    if (_value.repeatStatusType == 0) {
      if (_value.repeatStatusValues.length == 7) {
        return '每天';
      }
      final daysMap = Constant.weekDaysShort.asMap();
      final values = _value.repeatStatusValues..sort((a, b) => a - b);
      return values.map((i) => daysMap[i]).toList().join('、');
    }

    if (_value.repeatStatusType == 1) {
      return '每周第 ${_value.repeatStatusValues[0] + 1} 天';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _value = widget.habit;
    _nameFocusNode = FocusNode();
    _nameController = TextEditingController(text: _value.name);
    _remarksController = TextEditingController(text: _value.remarks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GsColors.of(context).background,
      appBar: GsAppBar(
        middle: Text('新建习惯'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('取消', style: TextStyle(fontSize: 15, color: GsColors.of(context).primary)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('保存', style: TextStyle(fontSize: 15)),
          onPressed: _isSubmit ? () {
          } : null,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 6),
            children: <Widget>[
              TextFieldCell(
                title: '名称',
                hintText: '请输入习惯名称',
                controller: _nameController,
                focusNode: _nameFocusNode,
                autofocus: _value.name == '',
                onChanged: (String value) {
                  setState(() {
                    _isSubmit = value.trim().isNotEmpty;
                  });
                },
                onSubmitted: (String value) {
                  _nameFocusNode.nextFocus();
                },
              ),
              TextFieldCell(
                title: '备注',
                hintText: '请输入备注',
                controller: _remarksController,
                textInputAction: TextInputAction.newline,
                height: 80,
                maxLines: 99,
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  '基本信息',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: GsColors.of(context).text,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Cell(
                title: '重复',
                content: _repeatLabel,
                onTap: () => _openRepeatStatus(),
              ),
              Cell(
                title: '开始日期',
                content: '今天',
                onTap: () {},
              ),
              Cell(
                title: '提醒时间',
                content: '关',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openRepeatStatus() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return RepeatStatusPicker(
          statusType: _value.repeatStatusType,
          statusValues: _value.repeatStatusValues,
          onChanged: (value) {
            setState(() {
              _value.repeatStatusType = value['type'] as int;
              _value.repeatStatusValues = value['values'] as List<int>;
            });
          },
        );
      },
    );
  }
}
