import 'package:flutter/material.dart';
import 'package:grass/screens/menu/menu.dart';
import 'package:grass/screens/scheme_list/scheme_list.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/side_menu/side_menu.dart';

class ContainerLayout extends StatefulWidget {
  ContainerLayout({Key key}) : super(key: key);

  @override
  _ContainerLayoutState createState() => _ContainerLayoutState();
}

class _ContainerLayoutState extends State<ContainerLayout> {
  final GlobalKey<GrassSideMenuState> _sideMenuKey = GlobalKey<GrassSideMenuState>();

  @override
  void initState() {
    super.initState();
    Constant.emitter.on('drawer@toggle', (data) => _sideMenuKey.currentState.toggle());
  }

  @override
  Widget build(BuildContext context) {
    return GrassSideMenu(
      key: _sideMenuKey,
      menu: MenuScreen(),
      content: SchemeListScreen(),
    );
  }
}
