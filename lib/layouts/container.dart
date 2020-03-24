import 'package:flutter/material.dart';
import 'package:grass/screens/habit/habit.dart';
import 'package:grass/screens/menu/menu.dart';
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
    '/setting': (context) => HabitScreen(),
  };

  String _routeName = '/';

  @override
  void initState() {
    super.initState();
    Constant.emitter.on('drawer@toggle', (data) => _sideMenuKey.currentState.toggle());
    Constant.emitter.on('drawer@selected', (data) {
      _sideMenuKey.currentState.close();
      setState(() {
        _routeName = data['routeName'] ?? '/';
      });
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
