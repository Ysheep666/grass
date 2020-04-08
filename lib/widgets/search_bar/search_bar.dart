import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grass/utils/colors.dart';

const _cacelButtonWidth = 88.0;

class GsSearchBar extends StatefulWidget {
  GsSearchBar({
    Key key,
    this.hintText = '',
    this.searchBarHeight = 58,
    this.searchBarPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
  }) : super(key: key);

  final String hintText;
  final double searchBarHeight;
  final EdgeInsetsGeometry searchBarPadding;

  @override
  _GsSearchBarState createState() => _GsSearchBarState();
}

class _GsSearchBarState extends State<GsSearchBar> {
  FocusNode _focusNode = FocusNode();
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if(_focusNode.hasFocus != _animate) {
        setState(() {
          _animate = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  _cancel() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final widthMax = MediaQuery.of(context).size.width;
    return Container(
      height: widget.searchBarHeight,
      padding: widget.searchBarPadding,
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: double.infinity,
            width: _animate ? widthMax - _cacelButtonWidth : widthMax,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: GsColors.of(context).backgroundGrayB,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: CupertinoTextField(
                focusNode: _focusNode,
                placeholder: '搜索',
                placeholderStyle: TextStyle(color: GsColors.of(context).gray),
                prefix: Icon(CupertinoIcons.search, size: 20, color: GsColors.of(context).grayB),
                clearButtonMode: OverlayVisibilityMode.editing,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _cancel,
              child: AnimatedOpacity(
                opacity: _animate ? 1 : 0,
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 200),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(_animate ? 0 : _cacelButtonWidth, 0, 0),
                  width: _cacelButtonWidth,
                  child: Container(
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('取消', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
