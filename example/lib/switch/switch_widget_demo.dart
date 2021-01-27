import 'package:example/layout/sample.dart';
import 'package:example/layout/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:widget/widget.dart';

class SwitchWidgetDemo extends StatefulWidget {
  @override
  _SwitchWidgetDemoState createState() => _SwitchWidgetDemoState();
}

class _SwitchWidgetDemoState extends State<SwitchWidgetDemo> {

  var enable_1 = true;
  var value_1 = false;

  @override
  Widget build(BuildContext context) {
    return Sample(
      'SwitchWidget',
      describe: 'SwitchWidget支持打开、关闭的提示；支持为 Slider 设置装饰；支持灵活的配置可用状态',
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: <Widget>[
            TitleWidget("自定义Switch大小"),
            Gaps.vGap10,
            buildSwitch(),
            Gaps.vGap10,
            buildDesc("SwitchWidget自定义尺寸：宽度:60,高度：30"),


            TitleWidget("Switch包含子布局"),
            Gaps.vGap10,
            buildSwitchWithChild(),
            Gaps.vGap10,
            buildDesc("SwitchWidget 支持自定义提示组件\n"
                "通过 unselectedChild 和 selectedChild 属性"),
            Gaps.vGap16,


            TitleWidget("Switch禁用状态"),
            Gaps.vGap10,
            buildDisableSwitch(),
            buildDesc("通过 enable 属性可以设置 SwitchWidget 的可用状态"),
            Gaps.vGap16,

            TitleWidget("Switch拖动效果"),
            Gaps.vGap10,
            buildDragSwitch(),
            Gaps.vGap10,
            buildDesc("SwitchWidget 除了支持点击切换状态，也支持拖拽手势"),
          ],
        ),
      ),
    );
  }

  buildDragSwitch() {
    return SwitchWidget(
      width: 300,
      height: 38,
      onChanged: (bool value) {},
      sliderChild: Text(
        "😃",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  buildDisableSwitch() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: <Widget>[
            Text(
              enable_1 ? "可用状态" : "不可用状态",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Gaps.vGap10,
            SwitchWidget(
              onChanged: (bool value) {
                value_1 = value;
              },
              open: value_1,
              enable: enable_1,
              shadowColor: Colors.black.withOpacity(0.5),
              shadowBlur: 3.0,
            ),
            Gaps.vGap10,
            RaisedButton(
              onPressed: () {
                setState(() {
                  enable_1 = !enable_1;
                });
              },
              child: Text("切换状态",style: TextStyle(color: Colors.white),),
              color: ThemeWidget.getTheme(context).primaryColor,
            )
          ],
        );
      },
    );
  }

  buildSwitchWithChild() {
    return Container(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SwitchWidget(
            width: 65.0,
            height: 35.538,
            onChanged: (v) {},
            closeChild: Text(
              "Off",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
            openChild: Text(
              "On",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
          SwitchWidget(
            open: true,
            onChanged: (v) {},
            closeChild: Icon(
              Icons.close,
              size: 16,
              color: Colors.white,
            ),
            openChild: Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            ),
          ),
          SwitchWidget(
            width: 65.0,
            height: 35.538,
            onChanged: (v) {},
            closeChild: Text(
              "😒",
              style: TextStyle(fontSize: 20),
            ),
            openChild: Text(
              "😃",
              style: TextStyle(fontSize: 20),
            ),
            childOffset: 3.0,
          ),
        ],
      ),
    );
  }

  buildSwitch() {
    return SwitchWidget(
      height: 30,
      width: 60,
      onChanged: (v) {},
    );
  }

  buildDesc(String desc) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          desc,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ));
  }
}
