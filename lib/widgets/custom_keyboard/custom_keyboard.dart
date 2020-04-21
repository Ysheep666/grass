import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/widgets/icons/icons.dart';

const double _keyButtonSpacing = 6;
const double _keyButtonHeight = 48;

class GsCustomKeyboard extends StatefulWidget {
  static double get preferredHeight {
    MediaQueryData _mediaQueryData  = MediaQueryData.fromWindow(window);
    // padding + 4 * button height + 3 * spacing + aafearea button
    return 20 + 4 * _keyButtonHeight + 3 * _keyButtonSpacing + _mediaQueryData.padding.bottom;
  }

  GsCustomKeyboard({
    Key key,
    @required this.textEditingController,
    this.onHide,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final VoidCallback onHide;

  @override
  GsCustomKeyboardState createState() => GsCustomKeyboardState();
}

class GsCustomKeyboardState extends State<GsCustomKeyboard> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  TextEditingController _textEditingController;

  set textEditingController(TextEditingController value) {
    _textEditingController = value;
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.textEditingController;
    _animationController = AnimationController(value: 0, vsync: this)
        ..addListener(() {
          setState(() {});
        })
        ..fling(velocity: 1);
  }

  open() {
    _animationController.fling(velocity: 1);
  }

  dismiss() {
    _animationController.fling(velocity: -1);
  }

  _input(String value) {
    if (_textEditingController != null) {
      final selection = _textEditingController.selection;
      final splitText = _textEditingController.text.split('').toList();
      if (selection.start == selection.end) {
        splitText.insert(selection.start, value);
      } else {
        splitText.replaceRange(selection.start, selection.end, [value]);
      }
      _textEditingController.value = TextEditingValue(
        text: splitText.join(''),
        selection: TextSelection.collapsed(offset: selection.start + value.length)
      );
    }
  }

  _delete() {
    if (_textEditingController != null) {
      final selection = _textEditingController.selection;
      final splitText = _textEditingController.text.split('').toList();
      final start = selection.start == selection.end ? selection.start - 1 : selection.start;
      splitText.replaceRange(start, selection.end, []);
      _textEditingController.value = TextEditingValue(
        text: splitText.join(''),
        selection: TextSelection.collapsed(offset: start)
      );
    }
  }

  List<Widget> _spacingColumnItems(List<Widget> items, {double spacing = _keyButtonSpacing}) {
    List<Widget> value = [SizedBox(height: _keyButtonHeight, child: items.first)];
    items.skip(1).forEach((element) {
      value.add(SizedBox(width: spacing, height: spacing));
      value.add(SizedBox(
        height: _keyButtonHeight,
        child: element
      ));
    });
    return value;
  }

  List<Widget> _spacingRowItems(List<Widget> items, {double spacing = _keyButtonSpacing}) {
    List<Widget> value = [Expanded(flex: 1, child: items.first)];
    items.skip(1).forEach((element) {
      value.add(SizedBox(width: spacing, height: spacing));
      value.add(Expanded(
        flex: 1,
        child: element
      ));
    });
    return value;
  }

  Widget _inputButton(String value) {
    return GsCustomKeyboardButton(
      child: Text(value),
      onPressed: () => _input(value),
    );
  }

  Widget _hideKeyboardButton() {
    return GsCustomKeyboardButton(
      child: Image(
        image: AssetImage('assets/images/keyboard.png'),
        height: 24,
        color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
      ),
      reverseBackgroundColor: true,
      onPressed: () {
        if (widget.onHide != null) {
          widget.onHide();
        }
      },
    );
  }

  Widget _plusButton() {
    return GsCustomKeyboardButton(
      child: Icon(FeatherIcons.plus, size: 30, color: CupertinoDynamicColor.resolve(CupertinoColors.label, context)),
      reverseBackgroundColor: true,
      onPressed: () {
        if (widget.onHide != null) {
          widget.onHide();
        }
      },
    );
  }

  Widget _minusButton() {
    return GsCustomKeyboardButton(
      child: Icon(FeatherIcons.minus, size: 30, color: CupertinoDynamicColor.resolve(CupertinoColors.label, context)),
      reverseBackgroundColor: true,
      onPressed: () {
        if (widget.onHide != null) {
          widget.onHide();
        }
      },
    );
  }

  Widget _deleteButton() {
    return GsCustomKeyboardButton(
      child: Image(
        image: AssetImage('assets/images/delete.png'),
        height: 24,
        color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
      ),
      reverseBackgroundColor: true,
      onPressed: () => _delete(),
    );
  }

  Widget _doneButton() {
    return GsCustomKeyboardButton(
      child: Text('下一个', style: TextStyle(
        fontSize: 20,
      )),
      reverseBackgroundColor: true,
      highlightedColor: Colors.white,
      highlightedBackgroundColor: CupertinoDynamicColor.resolve(CupertinoColors.systemBlue, context),
      onPressed: () {
        FocusScope.of(context).nextFocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, (1 - _animationController.value) * GsCustomKeyboard.preferredHeight),
      child: Container(
        width: double.infinity,
        height: GsCustomKeyboard.preferredHeight,
        color: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
          color: Color(0xFFD1D4D9), 
          darkColor: Color(0xFF595959),
        ), context),
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _spacingColumnItems([
              Row(
                children: _spacingRowItems([
                  _inputButton('1'),
                  _inputButton('2'),
                  _inputButton('3'),
                  _hideKeyboardButton(),
                ]),
              ),
              Row(
                children: _spacingRowItems([
                  _inputButton('4'),
                  _inputButton('5'),
                  _inputButton('6'),
                  _plusButton(),
                ]),
              ),
              Row(
                children: _spacingRowItems([
                  _inputButton('7'),
                  _inputButton('8'),
                  _inputButton('9'),
                  _minusButton(),
                ]),
              ),
              Row(
                children: _spacingRowItems([
                  _inputButton('.'),
                  _inputButton('0'),
                  _deleteButton(),
                  _doneButton(),
                ]),
              ),
            ]),
          ),
        )
      ),
    );
  }
}

class GsCustomKeyboardButton extends StatefulWidget {
  GsCustomKeyboardButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.reverseBackgroundColor = false,
    this.defaultColor,
    this.highlightedColor,
    this.defaultBackgroundColor,
    this.highlightedBackgroundColor,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final bool reverseBackgroundColor;
  final Color defaultColor;
  final Color highlightedColor;
  final Color defaultBackgroundColor;
  final Color highlightedBackgroundColor;

  @override
  _GsCustomKeyboardButtonState createState() => _GsCustomKeyboardButtonState();
}

class _GsCustomKeyboardButtonState extends State<GsCustomKeyboardButton> {
  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = false;
      });
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = widget.defaultColor ?? CupertinoDynamicColor.resolve(CupertinoColors.label, context);
    final highlightedColor = widget.highlightedColor ?? CupertinoDynamicColor.resolve(CupertinoColors.label, context);
    final defaultBackgroundColor = widget.defaultBackgroundColor ?? CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
      color: Color(0xFFFFFFFF), 
      darkColor: Color(0xFF595959),
    ), context);
    final highlightedBackgroundColor = widget.highlightedBackgroundColor ?? CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
      color: Color(0xFFB9BFC9), 
      darkColor: Color(0xFF595959),
    ), context);
    final color = _buttonHeldDown != widget.reverseBackgroundColor ? highlightedColor : defaultColor;
    final backgroundColor = _buttonHeldDown != widget.reverseBackgroundColor ? highlightedBackgroundColor : defaultBackgroundColor;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: Semantics(
        button: true,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                  color: Color(0xFF989C9E), 
                  darkColor: Color(0xFF595959),
                ), context),
                offset: Offset(0, 1),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(6))
          ),
          child: DefaultTextStyle(
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              color: color,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
            child: widget.child
          ),
        )
      ),
    );
  }
}
