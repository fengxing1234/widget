import 'package:example/index_widget.dart';
import 'package:example/routes.dart';
import 'package:flutter/material.dart';
import 'package:widget/widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      config: MainConfig(),
      theme: MainTheme(),
      child: MaterialApp(
        title: 'Flutter 组件库',
        routes: routes,
        home: IndexWidget(),
      ),
    );
  }
}
