
import 'package:example/layout/sample.dart';
import 'package:example/layout/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:widget/widget.dart';

class LoadingWidgetDemo extends StatefulWidget {
  @override
  _LoadingWidgetDemoState createState() => _LoadingWidgetDemoState();
}

class _LoadingWidgetDemoState extends State<LoadingWidgetDemo> {
  bool isPaintBackground = false;
  @override
  Widget build(BuildContext context) {
    return Sample(
      'Loading加载框',
      describe: '支持通过ThemeWidget中的MainConfig进行全局配置,支持阻止父页面事件触发、返回按钮是否关闭、自定义位置、自定义提示消息',
      child:  Container(
          child: Column(
              children: <Widget>[
                TitleWidget('展示Success'),
                CustomButton('加载成功',
                  theme: ButtonType.primary,
                  onClick: ()=>showLoadSuccess(context:context,stopEvent: true),
                ),
                Gaps.vGap10,
                TitleWidget('展示Loading'),
                CustomButton("加载中",
                  theme: ButtonType.primary,
                  onClick: (){
                    var hide = showLoading(context:context);
                    Future.delayed(Duration(seconds: 5),(){
                      hide();
                    });
                  },
                ),
              ]
          )
      ),
    );
  }
}
