import 'package:example/layout/sample.dart';
import 'package:example/layout/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:widget/widget.dart';

class OptionsWidgetDemo extends StatefulWidget{
  @override
  _OptionsDemoState createState() => _OptionsDemoState();
}

class _OptionsDemoState extends State<OptionsWidgetDemo>{
  static final List<Map> dataList = [
    {'name':'正南方', 'value': '100'},
    {'name':'正北方', 'value': '200'},
    {'name':'正东方', 'value': '300'},
    {'name':'正西方', 'value': '400'},
    {'name':'东南方', 'value': '500'},
    {'name':'东北方', 'value': '600'},
    {'name':'西南方', 'value': '700'},
    {'name':'西北方', 'value': '800'}
  ];
  @override
  Widget build(BuildContext context) {
    return Sample(
      '多选项组件',
      describe: '多选项组件支持单选，多选',
      child: Container(
        child: Column(
          children: [
            TitleWidget('支持多选的情况'),
            Padding(
              padding: EdgeInsets.all(15),
              child: ExpandMoreContentItem(
                isFirstExpandTop: true,
                isSetFirst: false,
                isExpand: true,
                single: false,
                models: ExpandModelList.formJson(dataList).list,
                expandTop: (list) {
                  if (list.isEmpty) {
                    return Future.value('');
                  }
                  print(list.map((a) => a.name + ' = ' + a.value));
                  String sss = list[0].value;
                  return Future.value(list[0].value);
                },
              ),
            ),
            Gaps.vGap10,
            TitleWidget('支持单选的情况'),
            Padding(
              padding: EdgeInsets.all(15),
              child: ExpandMoreContentItem(
                isFirstExpandTop: true,
                isSetFirst: false,
                isExpand: true,
                models: ExpandModelList.formJson(dataList).list,
                expandTop: (list) {
                  if (list.isEmpty) {
                    return Future.value('');
                  }
                  print(list.map((a) => a.name + ' = ' + a.value));
                  String sss = list[0].value;
                  return Future.value(list[0].value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}