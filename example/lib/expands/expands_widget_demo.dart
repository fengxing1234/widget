import 'package:example/layout/sample.dart';
import 'package:example/layout/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:widget/widget.dart';

class ExpandsWidgetDemo extends StatefulWidget{
  @override
  _ExpandsDemoState createState() => _ExpandsDemoState();
}

class _ExpandsDemoState extends State<ExpandsWidgetDemo>{
  @override
  Widget build(BuildContext context) {
    return Sample(
      '折叠组件',
      describe: '支持单个数据详情、列表数据的折叠展示',
      child: Container(
        child: Column(
          children: [
            _buildPanelTitle(),
            _buildPanelTitleShowText()
          ],
        ),
      ),
    );
  }

  /// 没有标题的折叠组件
  _buildPanelTitle(){
    List str = new List<String>();
    str.add('查看更多');
    str.add('收起');
    return Container(
      child: Column(
        children: [
          TitleWidget('没有标题的折叠组件'),
          Container(
            child: Column(
              children: [
                TitleWidget('数据展示'),
                SurveyExpansionView(
                  isBottom: true,
                  isShowLeft: false,
                  subTitleList: str,
                  callback: (expansion) {
                    print('expansion $expansion');
                  },
                  title: Text(''),
                  expansionList: _buildPushView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 有标题的折叠组件
  _buildPanelTitleShowText(){
    return Container(
      child: Column(
        children: [
          TitleWidget('有标题的折叠组件'),
          Container(
            child: Column(
              children: [
                SurveyExpansionView(
                  isShow: false,
                  isShowText: false,
                  title: SizedBox.shrink(),
                  subTitle: TitleWidget('数据展示'),
                  expansionList: _buildPushView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 折叠内容
  _buildPushView(){
    return Container(
      child: Column(
        children: [
          TitleWidget('第一条数据'),
          TitleWidget('第二条数据'),
          TitleWidget('第三条数据'),
        ],
      ),
    );
  }

}