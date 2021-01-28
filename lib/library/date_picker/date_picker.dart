import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'date_picker_constants.dart';
import 'date_picker_theme.dart';
import 'date_picker_widget.dart';
import 'time_picker_widget.dart';
enum DateTimePickerMode {
  date,
  datetime,
}

///日期选择控件
class DatePicker {
  ///
  /// context: [BuildContext]
  /// minDateTime: [DateTime] 最小时间
  /// maxDateTime: [DateTime] 最大时间
  /// initialDateTime: [DateTime] 默认被选中的时间
  /// dateFormat: [String] 日期格式化
  /// pickerTheme: [DateTimePickerTheme] 日期选择器的主题样式
  /// onCancel: [DateVoidCallback] 取消按钮触发的回调
  /// onClose: [DateVoidCallback] 关闭触发的回调
  /// onChange: [DateValueCallback] 选择的日期发生改变触发回调
  /// onConfirm: [DateValueCallback] 确认按钮触发的回调
  static void showDatePicker(
      BuildContext context, {
        DateTime minDateTime,
        DateTime maxDateTime,
        DateTime initialDateTime,
        String dateFormat,
        DateTimePickerTheme pickerTheme: DateTimePickerTheme.Default,
        DateTimePickerMode pickerMode: DateTimePickerMode.date,
        DateVoidCallback onCancel,
        DateVoidCallback onClose,
        DateValueCallback onChange,
        DateValueCallback onConfirm,
        bool onMonthChangeStartWithFirstDate = false,
      }) {
    if (minDateTime == null) {
      minDateTime = DateTime.parse(DATE_PICKER_MIN_DATETIME);
    }
    if (maxDateTime == null) {
      maxDateTime = DateTime.parse(DATE_PICKER_MAX_DATETIME);
    }
    if (initialDateTime == null) {
      initialDateTime = DateTime.now();
    }
    if (dateFormat != null && dateFormat.length > 0) {

    } else {
      dateFormat = DATETIME_PICKER_DATE_FORMAT;
    }

    Navigator.push(
      context,
      new _DatePickerRoute(
        onMonthChangeStartWithFirstDate: onMonthChangeStartWithFirstDate,
        minDateTime: minDateTime,
        maxDateTime: maxDateTime,
        initialDateTime: initialDateTime,
        dateFormat: dateFormat,
        pickerMode: pickerMode,
        pickerTheme: pickerTheme,
        onCancel: onCancel,
        onChange: onChange,
        onConfirm: onConfirm,
        theme: Theme.of(context, shadowThemeOnly: true),
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    ).whenComplete(onClose ?? () => {});
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.onMonthChangeStartWithFirstDate,
    this.minDateTime,
    this.maxDateTime,
    this.initialDateTime,
    this.dateFormat,
    this.pickerTheme,
    this.pickerMode,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final DateTime minDateTime, maxDateTime, initialDateTime;
  final String dateFormat;
  final DateTimePickerTheme pickerTheme;
  final DateTimePickerMode pickerMode;
  final VoidCallback onCancel;
  final DateValueCallback onChange;
  final DateValueCallback onConfirm;
  final bool onMonthChangeStartWithFirstDate;

  final ThemeData theme;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    double height = pickerTheme.pickerHeight;
    if (pickerTheme.title != null || pickerTheme.showTitle) {
      height += pickerTheme.titleHeight;
    }

    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(route: this, pickerHeight: height),
    );

    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _DatePickerComponent extends StatelessWidget {
  final _DatePickerRoute route;
  final double _pickerHeight;

  _DatePickerComponent({Key key, @required this.route, @required pickerHeight})
      : this._pickerHeight = pickerHeight;

  @override
  Widget build(BuildContext context) {
    Widget pickerWidget;
    if(route.pickerMode==DateTimePickerMode.date) {
      pickerWidget = DatePickerWidget(
        onMonthChangeStartWithFirstDate:
        route.onMonthChangeStartWithFirstDate,
        minDateTime: route.minDateTime,
        maxDateTime: route.maxDateTime,
        initialDateTime: route.initialDateTime,
        dateFormat: route.dateFormat,
        pickerTheme: route.pickerTheme,
        onCancel: route.onCancel,
        onChange: route.onChange,
        onConfirm: route.onConfirm,
      );
    }else{
      pickerWidget = DateTimePickerWidget(
        minDateTime: route.minDateTime,
        maxDateTime: route.maxDateTime,
        initDateTime: route.initialDateTime,
        dateFormat: route.dateFormat,
        pickerTheme: route.pickerTheme,
        onCancel: route.onCancel,
        onChange: route.onChange,
        onConfirm: route.onConfirm,
      );
    }
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate: new _BottomPickerLayout(route.animation.value,
                  contentHeight: _pickerHeight),
              child: pickerWidget,
            ),
          );
        },
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.contentHeight});

  final double progress;
  final double contentHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: contentHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
