import 'package:example/layout/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:example/layout/sample.dart';
import 'package:widget/widget.dart';

class CustomButtonDemo extends StatefulWidget {
  @override
  _CustomButtonDemoState createState() => _CustomButtonDemoState();
}

class _CustomButtonDemoState extends State<CustomButtonDemo> {
  // 是否显示加载
  bool loading = true;
  // 是否禁用
  bool disabled = true;

  @override
  Widget build(BuildContext context) {
    return Sample(
        'CustomButton',
        describe: 'CustomButton支持自定义大小、颜色、是否可点击、hollow效果、加载效果',
        child: Container(
            child: Column(
                children: <Widget>[
                  // 按钮
                  TitleWidget('按钮'),
                  CustomButton('default'),
                  Gaps.vGap10,
                  CustomButton(
                      'primary',
                      theme: ButtonType.primary
                  ),
                  Gaps.vGap10,
                  CustomButton(
                      '自定义颜色',
                      config: ButtonConfig(
                        fontColor: Colors.white,
                        bgColor: Colors.cyan
                      ),
                  ),
                  Gaps.vGap10,
                  TitleWidget('disabled 状态'),
                  // 禁用状态
                  CustomButton('default 禁用状态', disabled: disabled),
                  Gaps.vGap10,
                  Gaps.vGap10,
                  CustomButton(
                      'primary 禁用状态',
                      theme: ButtonType.primary,
                      disabled: disabled
                  ),
                  Gaps.vGap10,
                  CustomButton(
                      'primary',
                      theme: ButtonType.primary,
                      hollow: true,
                      disabled: disabled
                  ),
                  Gaps.vGap10,

                  TitleWidget('loading 状态'),
                  CustomButton('加载中', loading: loading),
                  Gaps.vGap10,
                  CustomButton(
                    '加载中',
                    theme: ButtonType.primary,
                    loading: loading,
                  ),
                  Gaps.vGap10,
                  // box,
                  TitleWidget('hollow效果'),
                  // hollow
                  CustomButton(
                      'default',
                      hollow: true
                  ),
                  Gaps.vGap10,
                  CustomButton(
                      'primary',
                      theme: ButtonType.primary,
                      hollow: true
                  ),
                  Gaps.vGap10,
                  TitleWidget('自定义大小'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton('default',config: ButtonConfig(
                        height: 35,
                        width: 80,
                        fontSize: 14,
                      ),),
                      CustomButton('primary',config: ButtonConfig(
                        height: 35,
                        width: 80,
                        fontSize: 14,
                      ),theme: ButtonType.primary,),
                    ],
                  )
                ]
            )
        )
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
