import 'package:example/base_widget.dart';
import 'package:example/button/custom_button_demo.dart';
import 'package:example/expands/expands_widget_demo.dart';
import 'package:example/date_picker/date_picker_demo.dart';
import 'package:example/loading/loading_widget_demo.dart';
import 'package:example/options/options_widget_demo.dart';
import 'package:example/switch/switch_widget_demo.dart';
import 'package:flutter/material.dart';
import 'package:example/edit/custom_edit_view_demo.dart';

final routeLists = [
  {
    'title': '表单',
    'icon': 'assets/images/index-icon/icon_nav_form.png',
    'children': [
      {
        'title': 'Button',
        'url': '/button'
      },
      {
        'title': 'Switch',
        'url': '/switch'
      },
      {
        'title': 'TextField',
        'url': '/input'
      },
    ]
  },
  {
    'title': '基础组件',
    'icon': 'assets/images/index-icon/icon_nav_layout.png',
    'children': [
      {
        'title': '多选项组件',
        'url': '/optionsWidget'
      },
      {
        'title': '多功能按钮组件',
        'url': '/rotationBtnWidget'
      },
      {
        'title': '折叠组件',
        'url': '/expandsWidget'
      },
    ]
  },
  {
    'title': '展示组件',
    'icon': 'assets/images/index-icon/icon_nav_layout.png',
    'children': [
      {
        'title': 'Collapse展开折叠列表控件',
        'url': '/collapseList'
      },
    ]
  },
  {
    'title': '操作反馈',
    'icon': 'assets/images/index-icon/icon_nav_feedback.png',
    'children': [
      {
        'title': 'DatePicker',
        'url': '/datePicker'
      },
      {
        'title': '对话框',
        'url': '/dialog'
      },
      {
        'title': 'Loading加载框',
        'url': '/loading'
      },
    ]
  }
];

final routes = <String, WidgetBuilder>{
  '/button':(_)=>BaseWidget('Button示例', 'lib/button/custom_button_demo', CustomButtonDemo()),

  '/switch':(_)=>BaseWidget('Switch示例', 'lib/switch/switch_widget_demo', SwitchWidgetDemo()),

  '/loading':(_)=>BaseWidget('Loading加载框示例', 'lib/loading/loading_widget_demo', LoadingWidgetDemo()),

  '/optionsWidget':(_)=>BaseWidget('Options示例', 'lib/options/options_widget_demo', OptionsWidgetDemo()),

  '/expandsWidget':(_)=>BaseWidget('Expands示例', 'lib/expands/expands_widget_demo', ExpandsWidgetDemo()),

  '/datePicker':(_)=>BaseWidget('日期选择控件示例', 'lib/date_picker/date_picker_demo', DatePickerDemo()),

  '/input':(_)=>BaseWidget('Edit示例', 'lib/edit/custom_edit_view_demo', CustomEditViewDemo()),

};