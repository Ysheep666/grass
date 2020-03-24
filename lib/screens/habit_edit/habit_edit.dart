import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';

class HabitEditScreen extends StatefulWidget {
  HabitEditScreen({Key key}) : super(key: key);

  @override
  HabitEditScreenState createState() => HabitEditScreenState();
}

class HabitEditScreenState extends State<HabitEditScreen> {
  FocusNode _nameFocusNode;
  TextEditingController _nameController;
  TextEditingController _remarksController;

  bool _isSubmit = false;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _nameController = TextEditingController(text: '');
    _remarksController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GsColors.of(context).background,
      appBar: GsAppBar(
        backgroundColor: GsColors.of(context).background,
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
        shadow: false,
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 6),
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _nameController, 
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(
                    hintText: '名称',
                    hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFFD2D2D2)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textInputAction: TextInputAction.next,
                  cursorColor: Color(0xFF0290FF),
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
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _remarksController, 
                  decoration: InputDecoration(
                    hintText: '备注',
                    hintStyle: TextStyle(color: Color(0xFFD2D2D2)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  style: TextStyle(fontSize: 14, height: 1.5),
                  maxLines: 99,
                  cursorColor: Color(0xFF0290FF),
                ),
              ),
              MaterialButton(
                child: Text('点击我'),
                onPressed: () {
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
