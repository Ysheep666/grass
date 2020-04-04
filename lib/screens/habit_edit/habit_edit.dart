import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/utils/helper.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/cell/cell.dart';
import 'package:grass/widgets/cell/text_field_cell.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'alert_time_picker.dart';
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
    if (_value.repeatStatusType == HabitRepeatStatusType.day) {
      if (_value.repeatStatusValues.length == 7) {
        return '每天';
      }
      final daysMap = Constant.weekDaysShort.asMap();
      final values = _value.repeatStatusValues..sort((a, b) => a - b);
      return values.map((i) => daysMap[i]).toList().join('、');
    }
    if (_value.repeatStatusType == HabitRepeatStatusType.week) {
      return '每周第 ${_value.repeatStatusValues[0] + 1} 天';
    }
    return '每间隔 ${_value.repeatStatusValues[0]} 天';
  }

  String get _startDateLabel {
    return dateTimeFromNow(_value.startDate);
  }

  String get _alertTimeLabel {
    if (_value.alertTime == null) {
      return '关';
    }
    return DateFormat('a h:mm', 'zh_CH').format(_value.alertTime);
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
  void dispose() {
    _nameFocusNode.dispose();
    _nameController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _openRepeatStatus() {
    FocusScope.of(context).unfocus();
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
              _value.repeatStatusType = value['type'] as HabitRepeatStatusType;
              _value.repeatStatusValues = value['values'] as List<int>;
            });
          },
        );
      },
    );
  }

  void _openStartDate() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _value.startDate,
            onDateTimeChanged: (value) {
              setState(() {
                _value.startDate = value;
              });
            },
          ),
        );
      },
    );
  }

  void _openAlertTime() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AlertTimePicker(
          alertTime: _value.alertTime,
          onChanged: (value) {
            setState(() {
              _value.alertTime = value;
            });
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitStore = Provider.of<HabitStore>(context);
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
          onPressed: _isSubmit ? () async {
            _value.name = _nameController.text;
            _value.remarks = _remarksController.text;
            await habitStore.save(_value);
            showToast('✌️保存成功✌️');
            Navigator.pop(context);
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
                keyboardType: TextInputType.multiline,
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
                content: _startDateLabel,
                onTap: () => _openStartDate(),
              ),
              Cell(
                title: '提醒时间',
                content: _alertTimeLabel,
                onTap: () => _openAlertTime(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
