import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/motion_content.dart';
import 'package:grass/models/motion_group_record.dart';
import 'package:grass/stores/habit_detail_store.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/utils/helper.dart';
import 'package:grass/widgets/custom_keyboard/custom_keyboard.dart';
import 'package:grass/widgets/form_input/form_input.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';

class MotionGroupRecordItem extends StatefulWidget {
  MotionGroupRecordItem({
    Key key,
    this.index,
    this.motionGroupRecord,
  }) : super(key: key);

  final int index;
  final MotionGroupRecord motionGroupRecord;

  @override
  _MotionGroupRecordItemState createState() => _MotionGroupRecordItemState();
}

class _MotionGroupRecordItemState extends State<MotionGroupRecordItem> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _update(MotionGroupRecord motionGroupRecord) {
    final habitDetailStore = Provider.of<HabitDetailStore>(context, listen: false);
    habitDetailStore.updateMotionGroupRecordByTemp(motionGroupRecord);
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.motionGroupRecord.isDone;
    TextStyle headerTextStyle = CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );

    List<Widget> items = [];
    items.add(Container(
      width: 30,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDone ? null : CupertinoDynamicColor.resolve(GsColors.grey2, context),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Text('${widget.index + 1}', style: headerTextStyle),
    ));

    items.add(Container(
      width: 100,
      height: 24,
      alignment: Alignment.center,
      child: Container(
        width: 18,
        height: 3,
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(GsColors.grey, context),
          borderRadius: const BorderRadius.all(Radius.circular(1.5)),
        ),
      )
    ));

    items.addAll(
      widget.motionGroupRecord.content.map((content) {
        return _Input(
          content: content,
          decoration: InputDecoration(
            hintText: content.defaultInputValue,
            hintStyle: TextStyle(
              color: CupertinoDynamicColor.resolve(CupertinoColors.placeholderText, context),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 1).copyWith(left: 2),
            filled: true,
            fillColor: isDone ? Colors.transparent : CupertinoDynamicColor.resolve(GsColors.grey2, context),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
          ),
          onChanged: (value) {
            content.inputValue = value;
            if (content.value == null || content.value == 0.0) {
              widget.motionGroupRecord.isDone = false;
            }
            _update(widget.motionGroupRecord);
          },
        );
      })
    );

    items.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CupertinoButton(
        padding: const EdgeInsets.all(0),
        color: isDone ? CupertinoDynamicColor.resolve(GsColors.green, context) : CupertinoDynamicColor.resolve(GsColors.grey2, context),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        minSize: 0,
        child: Container(
          width: 30,
          height: 24,
          alignment: Alignment.center,
          child: Icon(FeatherIcons.check, size: 20, color: 
            isDone ? Colors.white : CupertinoDynamicColor.resolve(CupertinoColors.label, context),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            widget.motionGroupRecord.isDone = !isDone;
            _update(widget.motionGroupRecord);
          }
        },
      ),
    ));

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: isDone ? CupertinoDynamicColor.resolve(GsColors.green, context).withOpacity(0.15) : null,
      child: Form(
        key: _formKey,
        child: Row(
          children: items,
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

class _Input extends StatefulWidget {
  const _Input({
    Key key,
    @required this.content,
    this.decoration,
    this.onChanged,
  }) : super(key: key);

  final MotionContent content;
  final InputDecoration decoration;
  final ValueChanged<String> onChanged;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<_Input> {
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
