import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grass/utils/colors.dart';

/// 封装输入框
class TextFieldCell extends StatelessWidget {
  const TextFieldCell({
    Key key,
    @required this.title,
    this.hintText = '',
    this.controller,
    this.height = 50,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.border,
  }): super(key: key);

  final String title;
  final String hintText;
  final TextEditingController controller;
  final double height;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final FocusNode focusNode;
  final int maxLines;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final Border border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(left: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
          border: border ?? Border(
            bottom: Divider.createBorderSide(context, width: 0.6),
          )
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 46,
            alignment: Alignment.centerLeft,
            child: Text(title, style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
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
                  hintStyle: TextStyle(color: GsColors.of(context).primary),
                  border: InputBorder.none,
                ),
                textInputAction: textInputAction,
                inputFormatters: inputFormatters,
                cursorColor: GsColors.of(context).primary,
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
