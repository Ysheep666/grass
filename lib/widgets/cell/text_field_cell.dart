import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grass/utils/colors.dart';

/// 封装输入框
class TextFieldCell extends StatelessWidget {
  const TextFieldCell({
    Key key,
    @required this.title,
    this.hintText: '',
    this.controller,
    this.height = 50,
    this.keyboardType: TextInputType.text,
    this.textInputAction: TextInputAction.next,
    this.focusNode,
    this.autofocus = false,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
  }): super(key: key);

  final String title;
  final String hintText;
  final TextEditingController controller;
  final double height;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final int maxLines;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(left: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(context, width: 0.6),
          )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50,
            alignment: Alignment.centerLeft,
            child: Text(title, style: TextStyle(
              fontSize: 15,
              color: GsColors.of(context).text,
            ))
          ),
          SizedBox(width: 15),
          Expanded(
            child: Semantics(
              label: hintText.isEmpty ? '请输入$title' : hintText,
              child: TextField(
                focusNode: focusNode,
                keyboardType: keyboardType,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                ),
                textInputAction: textInputAction,
                cursorColor: Color(0xFF027AFF),
                maxLines: maxLines,
                autofocus: autofocus,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
