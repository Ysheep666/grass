import 'package:flutter/material.dart';
import 'package:grass/screens/habit/habit.dart';
import 'package:grass/screens/menu/menu.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/widgets/side_menu/side_menu.dart';

class ContainerLayout extends StatefulWidget {
  ContainerLayout({Key key}) : super(key: key);

  @override
  _ContainerLayoutState createState() => _ContainerLayoutState();
}

class _ContainerLayoutState extends State<ContainerLayout> {
  final GlobalKey<GsSideMenuState> _sideMenuKey = GlobalKey<GsSideMenuState>();
  final routes = {
    '/': (context) => HabitScreen(),
    '/calendar': (context) => HabitScreen(),
    '/count': (context) => HabitScreen(),
    '/trash': (context) => HabitScreen(),
    '/guide': (context) => HabitScreen(),
    '/setting': (context) => HabitScreen(),
  };

  String _routeName = '/';

  @override
  void initState() {
    super.initState();
    Constant.emitter.on('drawer@toggle', _toggleSideMenu);
    Constant.emitter.on('drawer@selected', _selected);
  }

  @override
  void dispose() {
    Constant.emitter.off('drawer@toggle', _toggleSideMenu);
    Constant.emitter.off('drawer@selected', _selected);
    super.dispose();
  }

  void _toggleSideMenu(data) {
    _sideMenuKey.currentState.toggle();
  }

  void _selected(data) {
    NativeMethod.impactFeedback(ImpactFeedbackStyle.light);
    _sideMenuKey.currentState.close();
    setState(() {
      _routeName = data['routeName'] ?? '/';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GsSideMenu(
      key: _sideMenuKey,
      menu: MenuScreen(routeName: _routeName),
      content: routes[_routeName](context),
    );
  }
}
