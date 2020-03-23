import 'package:flutter/material.dart';
import 'package:grass/layouts/container.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grass',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      routes: {
        '/': (context) => ContainerLayout(),
      },
    );
  }
}

void main() async {
  runApp(MyApp());
}
