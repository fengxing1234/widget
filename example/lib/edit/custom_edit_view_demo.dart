import 'package:example/layout/sample.dart';
import 'package:example/layout/title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget/widget.dart';

class CustomEditViewDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomEditViewDemo();
  }
}

class _CustomEditViewDemo extends State<CustomEditViewDemo> {
  ///边框宽度编辑器
  TextEditingController frameWidthController = new TextEditingController();

  ///边框圆角控制器编辑器
  TextEditingController frameRadiusController = new TextEditingController();

  ///边框颜色控制器编辑器
  TextEditingController frameColorController = new TextEditingController();

  ///标题颜色控制器编辑器
  TextEditingController titleColorController = new TextEditingController();

  ///标题字体大小控制器编辑器
  TextEditingController titleSizeController = new TextEditingController();

  ///标题内容控制器编辑器
  TextEditingController titleContentController = new TextEditingController();

  ///标题颜色控制器编辑器
  TextEditingController editTextColorController = new TextEditingController();

  ///标题字体大小控制器编辑器
  TextEditingController editTextSizeController = new TextEditingController();

  int frameColor = 0xFF000000;
  double frameWidth = 1.0;
  double frameRadius = 5.0;

  String title = "";
  int titleColor = 0xFFaaaaaa;
  double titleSize = 15;

  int editTextColor = 0xFF000000;
  double editTextSize = 15;

  @override
  Widget build(BuildContext context) {
    return Sample('CustomEditView',
        describe:
            'CustomEditView支持控制字体风格（颜色，字体大小，粗细）、编辑框宽度、颜色、圆角，和设置标题以及标题大小颜色等，可以限制输入内容的类型，如纯数字，英文和数字等，',
        child: Container(
            child: Column(children: <Widget>[
          TitleWidget('自定义输入框'),
          CustomEditView(
            titleName: "边框宽度",
            hint: "请输入数字",
            controllerValue: frameWidthController,
            editTextStyle: TextStyle(
                fontSize: 15,
                color: Colors.black26,
                fontWeight: FontWeight.w500),
            isNum: true,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCCCCCC),
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          CustomEditView(
            hint: "请输入数字",
            titleName: "边框圆角",
            controllerValue: frameRadiusController,
            editTextStyle: TextStyle(
                fontSize: 15,
                color: Colors.black26,
                fontWeight: FontWeight.w500),
            isNum: true,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCCCCCC),
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          CustomEditView(
            hint: "请输入数字",
            titleName: "边框颜色",
            isNum: true,
            controllerValue: frameColorController,
            editTextStyle: TextStyle(
                fontSize: 15,
                color: Colors.black26,
                fontWeight: FontWeight.w500),
            length: 6,
            maxLines: 1,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCCCCCC),
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          CustomEditView(
            titleName: "标题内容",
            controllerValue: titleContentController,
            editTextStyle: TextStyle(
                fontSize: 15,
                color: Colors.black26,
                fontWeight: FontWeight.w500),
            length: 15,
            maxLines: 1,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCCCCCC),
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          CustomEditView(
            hint: "请输入数字",
            titleName: "标题颜色",
            isNum: true,
            controllerValue: titleColorController,
            editTextStyle: TextStyle(
                fontSize: 15,
                color: Colors.black26,
                fontWeight: FontWeight.w500),
            length: 6,
            maxLines: 1,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCCCCCC),
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          CustomEditView(
            hint: "请输入数字",
            titleName: "标题字体大小",
            controllerValue: titleSizeController,
            editTextStyle: TextStyle(
                fontSize: 15,
                color: Colors.black26,
                fontWeight: FontWeight.w500),
            isNum: true,
            length: 2,
            maxLines: 1,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCCCCCC),
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          CustomEditView(
            hint: "请输入数字",
            titleName: "编辑字体颜色",
            isNum: true,
            controllerValue: editTextColorController,
            editTextStyle: TextStyle(
                fontSize: 15,
                color: Colors.black26,
                fontWeight: FontWeight.w500),
            length: 6,
            maxLines: 1,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCCCCCC),
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          CustomEditView(
            hint: "请输入数字",
            titleName: "编辑字体大小",
            controllerValue: editTextSizeController,
            editTextStyle: TextStyle(
                fontSize: 15,
                color: Colors.black26,
                fontWeight: FontWeight.w500),
            isNum: true,
            length: 15,
            maxLines: 1,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFCCCCCC),
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF000000),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                "确定",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            onTap: () {
              setState(() {
                int parse = frameColorController.text != null &&
                        frameColorController.text != ""
                    ? int.parse("0xFF" + frameColorController.text)
                    : 0xFF000000;
                frameColor = parse;
                frameWidth = frameWidthController.text != null &&
                        frameWidthController.text != ""
                    ? double.parse(frameWidthController.text)
                    : 1;
                frameRadius = frameRadiusController.text != null &&
                        frameRadiusController.text != ""
                    ? double.parse(frameRadiusController.text)
                    : 5.0;
                int titleParse = titleColorController.text != null &&
                        titleColorController.text != ""
                    ? int.parse("0xFF" + titleColorController.text)
                    : 0xFF000000;
                titleColor = titleParse;
                titleSize = titleSizeController.text != null &&
                        titleSizeController.text != ""
                    ? double.parse(titleSizeController.text)
                    : 10;
                title = titleContentController.text != null &&
                        titleContentController.text != ""
                    ? titleContentController.text
                    : "";

                int editTextParse = editTextColorController.text != null &&
                        editTextColorController.text != ""
                    ? int.parse("0xFF" + editTextColorController.text)
                    : 0xFF000000;
                editTextColor = editTextParse;
                editTextSize = editTextSizeController.text != null &&
                        editTextSizeController.text != ""
                    ? double.parse(editTextSizeController.text)
                    : 10;
              });
            },
          ),
          CustomEditView(
            titleName: title,
            titleNameStyle:
                TextStyle(fontSize: titleSize, color: Color(titleColor)),
            editTextStyle: TextStyle(
                fontSize: editTextSize,
                color: Color(editTextColor),
                fontWeight: FontWeight.w500),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(frameColor),
                width: frameWidth,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(frameRadius),
            ),
          ),
          Gaps.vGap16,
        ])));
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
