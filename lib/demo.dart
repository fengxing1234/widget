import 'package:flutter/material.dart';

/// 项目：widget
/// 包层次结构：
/// 文件： demo
/// 创建者：fengxing
/// 创建时间：2021/1/22 下午2:25
/// 文件描述:
class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          item("1"),
          item("2"),
          item("3"),
          item("4"),
          item("5"),
          item("6"),
          item("7"),
          item("8"),
          item("9"),
          item("10"),
          item("11"),
        ],
      ),
    );
  }

  Widget item(String name) {
    return Text(name);
  }
}
