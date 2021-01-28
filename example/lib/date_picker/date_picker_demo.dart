import 'package:flutter/material.dart';
import 'package:widget/widget.dart';
import 'package:example/layout/sample.dart';
import 'package:example/layout/title_widget.dart';

class DatePickerDemo extends StatefulWidget {
  @override
  _DatePickerDemoState createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<DatePickerDemo> {
  @override
  Widget build(BuildContext context) {
    return Sample(
      '日期选择控件',
      describe: '日期选择控件支持设置日期选择范围、默认日期、自定义控件顶部',
      child: Container(
        child: Column(
          children: [
            TitleWidget('默认日期选择框'),
            CustomButton('默认(年月日)',
              theme: ButtonType.primary,
              onClick: (){
                DatePicker.showDatePicker(context,
                    onConfirm: (date, List<int> index) {
                      print("${DateUtil.formatDate(date, format: "yyyy-MM-dd")}");
                    },
                );
              },),
            Gaps.vGap10,
            TitleWidget('默认日期选择框(包含时分)'),
            CustomButton('默认(年月日时分)',
              theme: ButtonType.primary,
              onClick: (){
                DatePicker.showDatePicker(context,
                  ///模式改为datetime
                  pickerMode:DateTimePickerMode.datetime,
                  onConfirm: (date, List<int> index) {
                    print("${DateUtil.formatDate(date, format: "yyyy-MM-dd HH:mm:ss")}");
                  },
                  dateFormat: 'yyyy,MM,dd,HH,mm'
                );
              },),
            Gaps.vGap10,
            TitleWidget('自定义日期选择框'),
            CustomButton('自定义',
              theme: ButtonType.primary,
            onClick: (){
              DatePicker.showDatePicker(context,
                  onConfirm: (date, List<int> index) {
                    print("${DateUtil.formatDate(date, format: "yyyy/MM/dd")}");
                  },
                  pickerTheme: DateTimePickerTheme(
                    itemHeight: 42,
                    itemTextStyle: TextStyle(fontSize: 26),
                    confirm: Text(
                      "确定",
                      style: TextStyle(
                          fontSize: 16, color: ThemeWidget.getTheme(context).primaryColor),
                    ),
                    cancel: Text(
                      "关闭",
                      style: TextStyle(
                          fontSize: 16, color: ThemeWidget.getTheme(context).textColor),
                    ),
                  ),
                  ///最小日期限制
                  minDateTime: DateTime.parse("1994-01-01"),
                  ///最大日期限制
                  maxDateTime: DateTime.parse("2030-01-01"),
                  ///初始日期
                  initialDateTime: DateTime.parse("2020-06-01"),
                  ///日期列表选项格式
                  dateFormat: "yyyy年,MM月,dd日");
            },),
            Gaps.vGap10,
            TitleWidget('自定义日期选择框(包含时分)'),
            CustomButton('自定义(包含时分)',
              theme: ButtonType.primary,
              onClick: (){
                DatePicker.showDatePicker(context,
                    pickerMode:DateTimePickerMode.datetime,
                    onConfirm: (date, List<int> index) {
                      print("${DateUtil.formatDate(date, format: "yyyy/MM/dd")}");
                    },
                    pickerTheme: DateTimePickerTheme(
                      itemHeight: 42,
                      itemTextStyle: TextStyle(fontSize: 20),
                      confirm: Text(
                        "确定",
                        style: TextStyle(
                            fontSize: 16, color: ThemeWidget.getTheme(context).primaryColor),
                      ),
                      cancel: Text(
                        "关闭",
                        style: TextStyle(
                            fontSize: 16, color: ThemeWidget.getTheme(context).textColor),
                      ),
                    ),
                    ///最小日期限制
                    minDateTime: DateTime.parse("1994-01-01"),
                    ///最大日期限制
                    maxDateTime: DateTime.parse("2030-01-01"),
                    ///初始日期
                    initialDateTime: DateTime.parse("2020-06-01"),
                    ///日期列表选项格式
                    dateFormat: "yyyy年,MM月,dd日,HH时,mm分");
              },),
          ],
        ),
      ),
    );
  }
}
