import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/utils/colors.dart';
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

  Habit _habit;
  bool _isSubmit = false;

  @override
  void initState() {
    _habit = widget.habit;
    _nameFocusNode = FocusNode();
    _nameController = TextEditingController(text: _habit.name);
    _remarksController = TextEditingController(text: _habit.remarks);
    super.initState();
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
                autofocus: true,
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
                content: '每天',
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
          value: RepeatStatusPickerValue(
            _habit.repeatStatusType,
            _habit.repeatStatusValues,
          ),
          onChanged: (value) {
            setState(() {
              _habit.repeatStatusType = value.statusType;
              _habit.repeatStatusValues = value.statusValues;
            });
          },
        );
      },
    );
  }
}
