import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/motion_content.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/utils/helper.dart';
import 'package:grass/widgets/custom_keyboard/custom_keyboard.dart';
import 'package:grass/widgets/form_input/form_input.dart';

class ItemInput extends StatefulWidget {
  const ItemInput({
    Key key,
    @required this.content,
    this.decoration,
    this.onChanged,
  }) : super(key: key);

  final MotionContent content;
  final InputDecoration decoration;
  final ValueChanged<String> onChanged;

  @override
  ItemInputState createState() => ItemInputState();
}

class ItemInputState extends State<ItemInput> {
  FocusNode _focusNode;
  _KeyboardController _controller;

  @override
  void initState() {
    _focusNode = FocusNode();
    _controller = _KeyboardController(content: widget.content, text: widget.content.inputValue);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Constant.emitter.emit('habit_detail@show_keyboard', {
         'focusNode': _focusNode,
         'textEditingController': _controller,
        });
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decoration;
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        height: 24,
        child: FormInput(
          readOnly: true,
          showCursor: true,
          enableInteractiveSelection: true,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 15,
            height: 1.2,
            fontWeight: FontWeight.w500,
            textBaseline: TextBaseline.alphabetic,
          ),
          decoration: decoration,
          errorDecoration: decoration.copyWith(
            fillColor: CupertinoDynamicColor.resolve(GsColors.pink, context),
          ),
          toolbarOptions: ToolbarOptions(),
          focusNode: _focusNode,
          controller: _controller,
          validator: (value) => value.isEmpty ? '' : null,
        ),
      ),
    );
  }
}

class _KeyboardController extends GsCustomKeyboardController {
  _KeyboardController({
    @required this.content,
    String text,
  }) : super(text: text);

  final MotionContent content;

  bool get isDecimal => content.category == MotionCategory.weight || content.category == MotionCategory.distance;

  @override
  input(String input) {
    final selection = this.selection;
    final splitText = this.text.split('').toList();

    inputValue() {
      if (selection.start == selection.end) {
        splitText.insert(max(0, selection.start), input);
      } else {
        splitText.replaceRange(selection.start, selection.end, [input]);
      }

      return TextEditingValue(
        text: splitText.join(''),
        selection: TextSelection.collapsed(offset: selection.start + input.length)
      );
    }

    if (content.category == MotionCategory.duration) {
      final newValue = inputValue();
      if (newValue.text.length <= 8) {
        this.value = _formatDurationValue(newValue);
      }
    } else {
      final isContainsPoint = splitText.contains('.');
      final isNotMaxLength = (splitText.length + (isContainsPoint ? -1 : 0)) < 5;
      if (isNotMaxLength && (input != '.' || (input == '.' && splitText.length > 0 && !isContainsPoint))) {
        final newValue = inputValue();
        if (double.parse(newValue.text) != 0) {
          this.value = newValue;
        }
      }
    }
  }

  @override
  delete() {
    final selection = this.selection;
    if (this.text.isEmpty || selection.end == 0) {
      return;
    }
    final splitText = this.text.split('').toList();
    final start = selection.start == selection.end ? selection.start - 1 : selection.start;
    splitText.replaceRange(start, selection.end, []);
    final newValue = TextEditingValue(
      text: splitText.join(''),
      selection: TextSelection.collapsed(offset: start)
    );

    if (content.category == MotionCategory.duration) {
      this.value = _formatDurationValue(newValue);
    } else {
      this.value = newValue;
    }
  }

  @override
  deleteAll() {
    final selection = this.selection;
    if (this.text.isEmpty || selection.end == 0) {
      return;
    }
    final splitText = this.text.split('').toList();
    splitText.replaceRange(0, selection.end, []);
    final newValue = TextEditingValue(
      text: splitText.join(''),
      selection: TextSelection.collapsed(offset: 0)
    );

    if (content.category == MotionCategory.duration) {
      this.value = _formatDurationValue(newValue);
    } else {
      this.value = newValue;
    }
  }

  TextEditingValue _formatDurationValue(TextEditingValue value) {
    if (value.text.isEmpty) {
      return value;
    }

    final newText = _formatDurationInput(value.text);
    final formatNewText = valueFromDuration(valueToDuration(newText));
    return TextEditingValue(
      text: formatNewText,
      selection: TextSelection.collapsed(offset: max(0, value.selection.start + (
        formatNewText.length - value.text.length
      ))),
    );
  }

  String _formatDurationInput(String inputValue) {
    return inputValue.split('').reversed.reduce((value, element) {
      if (element != ':') {
        if (value.length % 3 == 2 && value.length < 8) {
          return '$element:$value';
        }
        return '$element$value';
      }
      return value;
    });
  }
}
