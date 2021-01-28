import 'package:flutter/material.dart';

/// 项目：widget
/// 包层次结构：
/// 文件： test_widget
/// 创建者：fengxing
/// 创建时间：2021/1/22 下午2:36
/// 文件描述:
class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('基础Widget模块'),
      ),
      body: TestWidgetContent(),
    );
  }
}

class TestWidgetContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestWidgetContent();
}

class _TestWidgetContent extends State<TestWidgetContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('基础Widget'),
      ),
    );
  }
}
