import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/models/motion_content.dart';
import 'package:grass/models/motion_group_record.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/form_input/form_input.dart';
import 'package:grass/widgets/icons/icons.dart';

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

class _MotionGroupRecordItemState extends State<MotionGroupRecordItem> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        color: CupertinoDynamicColor.resolve(GsColors.grey2, context),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Text('${widget.index + 1}', style: headerTextStyle),
    ));

    items.add(Container(
      width: 108,
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
      widget.motionGroupRecord.content.map((value) {
        return _Input(
          content: value,
        );
      })
    );

    items.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        child: Container(
          width: 30,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: CupertinoDynamicColor.resolve(GsColors.grey2, context),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Icon(FeatherIcons.check, size: 20, color: CupertinoColors.label),
        ),
        onTap: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            print(widget.motionGroupRecord.content[0].toJson());
          }
        },
      ),
    ));

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _formKey,
        child: Row(
          children: items,
        ),
      ),
    );
  }
}

class _Input extends StatefulWidget {
  const _Input({
    Key key,
    @required this.content,
  }) : super(key: key);

  final MotionContent content;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<_Input> {
  FocusNode _focusNode;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Constant.emitter.emit('habit_detail@show_keyboard', {
         'focusNode': _focusNode,
         'textEditingController': _controller,
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      hintText: '',
      hintStyle: TextStyle(
        color: CupertinoDynamicColor.resolve(CupertinoColors.placeholderText, context),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
      filled: true,
      fillColor: CupertinoDynamicColor.resolve(GsColors.grey2, context),
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
    );
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        alignment: Alignment.center,
        height: 24,
        child: FormInput(
          readOnly: true,
          showCursor: true,
          enableInteractiveSelection: true,
          textAlign: TextAlign.center,
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 15,
            height: 20 / 15,
            textBaseline: TextBaseline.alphabetic,
          ),
          decoration: decoration,
          errorDecoration: decoration.copyWith(
            fillColor: CupertinoDynamicColor.resolve(GsColors.pink, context),
          ),
          focusNode: _focusNode,
          controller: _controller,
          validator: (value) {
            if (value.isEmpty) {
              return '';
            }
            return null;
          },
          onSaved: (value) {
            widget.content.value = double.parse(value);
          },
        ),
      ),
    );
  }
}
