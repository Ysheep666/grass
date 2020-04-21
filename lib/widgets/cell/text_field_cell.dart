import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 封装输入框
class TextFieldCell extends StatelessWidget {
  const TextFieldCell({
    Key key,
    @required this.title,
    this.placeholder = '',
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
  final String placeholder;
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
            height: 44,
            alignment: Alignment.centerLeft,
            child: Text(title, style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ))
          ),
          SizedBox(width: 15),
          Expanded(
            child: Semantics(
              label: placeholder.isEmpty ? '请输入$title' : placeholder,
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                textAlign: TextAlign.start,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 16,
                  height: 1.5,
                  textBaseline: TextBaseline.alphabetic,
                ),
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: TextStyle(
                    color: CupertinoDynamicColor.resolve(CupertinoColors.placeholderText, context),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                ),
                keyboardAppearance: CupertinoTheme.brightnessOf(context),
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                inputFormatters: inputFormatters,
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
