import 'package:flutter/material.dart';

class BaseContentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildContentBg();
  }

  /// 添加背景颜色以及边框
  _buildContentBg() {
    return Container(
      constraints: BoxConstraints(minHeight: 36),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border: Border.all(color: Color(0xFFCCCCCC), width: 0.5)),
      child: buildBgChild(),
    );
  }

  buildBgChild() {
    return Container();
  }
}
