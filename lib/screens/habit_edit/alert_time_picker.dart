import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grass/widgets/cell/switch_cell.dart';

class AlertTimePicker extends StatefulWidget {
  AlertTimePicker({
    Key key,
    this.alertTime,
    this.onChanged,
  }) : super(key: key);

  final DateTime alertTime;
  final ValueChanged<DateTime> onChanged;

  @override
  _AlertTimePickerState createState() => _AlertTimePickerState();
}

class _AlertTimePickerState extends State<AlertTimePicker> {
  DateTime _value;

  set _alertTime(DateTime value) {
    _value = value;
    widget.onChanged(value);
  } 

  @override
  void initState() {
    super.initState();
    _value = widget.alertTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Column(
        children: <Widget>[
          SwitchCell(
            title: '提醒',
            checked: _value != null,
            border: Border(bottom: BorderSide.none),
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() {
                if (_value == null) {
                  _alertTime = DateTime.now();
                } else {
                  _alertTime = null;
                }
              });
            },
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: _value,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  _alertTime = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}