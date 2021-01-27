
import 'package:example/routes.dart';
import 'package:flutter/material.dart';
import 'package:widget/widget.dart';
class IndexWidget extends StatefulWidget {
  @override
  _IndexWidgetState createState() => _IndexWidgetState();
}

class _IndexWidgetState extends State<IndexWidget> {
  // 标题padding
  final double titlePadding = 36.0;
  // 列表左右padding
  final double listPadding = 18.0;

  // 渲染标题
  Widget buildTitle(bool checked, int index, Widget child) {
    return Opacity(
        opacity: checked ? 0.5 : 1.0,
        child: Padding(
            padding: EdgeInsets.only(
                top: 25.0,
                right: listPadding,
                bottom: 25.0,
                left: listPadding
            ),
            child: Row(
                children: <Widget>[
                  // 名称
                  Expanded(
                      flex: 1,
                      child: child
                  ),
                  Image.asset(routeLists[index]['icon'], height: 22.0)
                ]
            )
        )
    );
  }

  // 渲染二级列表
  List<Widget> renderSubItem(subList) {
    final List<Widget> widgetList = [];

    // 循环数组
    subList.forEach((dynamic item) {
      final List<Widget> content = [
        Container(
            padding: EdgeInsets.only(
                top: 16.0,
                bottom: 16.0
            ),
            child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Text(item['title'], style: TextStyle(
                          fontSize: 16.0
                      ))
                  ),
                  Container(
                      child: Image.asset('assets/images/right-icon.png', height: 16.0)
                  )
                ]
            )
        )
      ];
      // 第一个不添加边框
      if (subList.indexOf(item) > 0) {
        content.insert(0, Divider(height: 1, color: Color(0xffd8d8d8)));
      }

      widgetList.add(
          InkWell(
              onTap: () {
                if (item['url'] == null) {
                  return;
                }
                Navigator.of(context).pushNamed(item['url']);
              },
              child: Padding(
                  padding: EdgeInsets.only(
                      left: listPadding,
                      right: listPadding
                  ),
                  child: Column(
                      children: content
                  )
              )
          )
      );
    });
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    final List<CollapseItem> children = [];
    final theme = ThemeWidget.getTheme(context);

    routeLists.forEach((item) {
      children.add(
          CollapseItem(
              title: Text(item['title'], style: TextStyle(
                  fontSize: 16.0
              )),
              child: Column(
                  children: renderSubItem(item['children'])
              )
          )
      );
    });

    return Scaffold(
        backgroundColor: Color(0xfff8f8f8),
        body: ListView(
            children: [
              // head
              Stack(
                  children: [
                    Container(
                        padding: EdgeInsets.all(36.0),
                        child: Column(
                            children: [
                              Row(
                                  children: [
                                    Text('Flutter 组件库', style: TextStyle(
                                        fontSize: 25.0
                                    ))
                                  ]
                              ),
                            ]
                        )
                    ),
                  ]
              ),
              Container(
                  padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10.0),
                  child: CollapseWidget(
                      card: true,
                      accordion: true,
                      buildTitle: buildTitle,
                      buildContent: (checked,index,child)=>child,
                      children: children
                  )
              )
            ]
        )
    );
  }
}
