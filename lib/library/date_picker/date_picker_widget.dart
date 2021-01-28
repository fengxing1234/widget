import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'date_picker_constants.dart';
import 'date_picker_theme.dart';


const String DATE_FORMAT_SEPARATOR = r'[|,-/\._: ]+';

const List<int> _solarMonthsOf31Days = const <int>[1, 3, 5, 7, 8, 10, 12];

/// 日期选择控件.
class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({
    Key key,
    this.onMonthChangeStartWithFirstDate,
    this.minDateTime,
    this.maxDateTime,
    this.initialDateTime,
    this.dateFormat: DATETIME_PICKER_DATE_FORMAT,
    this.pickerTheme: DateTimePickerTheme.Default,
    this.onCancel,
    this.onChange,
    this.onConfirm,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
    DateTime maxTime = maxDateTime ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);
    assert(minTime.compareTo(maxTime) < 0);
  }

  final DateTime minDateTime, maxDateTime, initialDateTime;
  final String dateFormat;
  final DateTimePickerTheme pickerTheme;

  final DateVoidCallback onCancel;
  final DateValueCallback onChange, onConfirm;
  final onMonthChangeStartWithFirstDate;

  @override
  State<StatefulWidget> createState() => _DatePickerWidgetState(
      this.minDateTime, this.maxDateTime, this.initialDateTime);
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _minDateTime, _maxDateTime;
  int _currYear, _currMonth, _currDay;
  List<int> _yearRange, _monthRange, _dayRange;
  FixedExtentScrollController _yearScrollCtrl, _monthScrollCtrl, _dayScrollCtrl;

  Map<String, FixedExtentScrollController> _scrollCtrlMap;
  Map<String, List<int>> _valueRangeMap;

  bool _isChangeDateRange = false;

  _DatePickerWidgetState(
      DateTime minDateTime, DateTime maxDateTime, DateTime initialDateTime) {
    // handle current selected year、month、day
    DateTime initDateTime = initialDateTime ?? DateTime.now();
    this._currYear = initDateTime.year;
    this._currMonth = initDateTime.month;
    this._currDay = initDateTime.day;

    // handle DateTime range
    this._minDateTime = minDateTime ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
    this._maxDateTime = maxDateTime ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);

    // limit the range of year
    this._yearRange = _calcYearRange();
    this._currYear = min(max(_minDateTime.year, _currYear), _maxDateTime.year);

    // limit the range of month
    this._monthRange = _calcMonthRange();
    this._currMonth = min(max(_monthRange.first, _currMonth), _monthRange.last);

    // limit the range of day
    this._dayRange = _calcDayRange();
    this._currDay = min(max(_dayRange.first, _currDay), _dayRange.last);

    // create scroll controller
    _yearScrollCtrl =
        FixedExtentScrollController(initialItem: _currYear - _yearRange.first);
    _monthScrollCtrl = FixedExtentScrollController(
        initialItem: _currMonth - _monthRange.first);
    _dayScrollCtrl =
        FixedExtentScrollController(initialItem: _currDay - _dayRange.first);

    _scrollCtrlMap = {
      'y': _yearScrollCtrl,
      'M': _monthScrollCtrl,
      'd': _dayScrollCtrl
    };
    _valueRangeMap = {'y': _yearRange, 'M': _monthRange, 'd': _dayRange};
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
          color: Colors.transparent, child: _renderPickerView(context)),
    );
  }

  /// render date picker widgets
  Widget _renderPickerView(BuildContext context) {
    Widget datePickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTheme.title != null || widget.pickerTheme.showTitle) {
      Widget titleWidget = DatePickerTitleWidget(
        pickerTheme: widget.pickerTheme,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(children: <Widget>[titleWidget, datePickerWidget]);
    }
    return datePickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    if (widget.onCancel != null) {
      widget.onCancel();
    }
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      DateTime dateTime = DateTime(_currYear, _currMonth, _currDay);
      widget.onConfirm(dateTime, _calcSelectIndexList());
    }
    Navigator.pop(context);
  }

  /// notify selected date changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      DateTime dateTime = DateTime(_currYear, _currMonth, _currDay);
      widget.onChange(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController _findScrollCtrl(String format) {
    FixedExtentScrollController scrollCtrl;
    _scrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    return scrollCtrl;
  }

  /// find item value range by specified format
  List<int> _findPickerItemRange(String format) {
    List<int> valueRange;
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    return valueRange;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = List<Widget>();
    List<String> formatArr =
    splitDateFormat(widget.dateFormat);
    formatArr.forEach((format) {
      List<int> valueRange = _findPickerItemRange(format);

      Widget pickerColumn = _renderDatePickerColumnComponent(
        scrollCtrl: _findScrollCtrl(format),
        valueRange: valueRange,
        format: format,
        valueChanged: (value) {
          if (format.contains('y')) {
            _changeYearSelection(value);
          } else if (format.contains('M')) {
            _changeMonthSelection(value);
          } else if (format.contains('d')) {
            _changeDaySelection(value);
          }
        },
      );
      pickers.add(pickerColumn);
    });
    return Container(
      color: widget.pickerTheme.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 38),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: pickers),
    );
  }

  Widget _renderDatePickerColumnComponent({
    @required FixedExtentScrollController scrollCtrl,
    @required List<int> valueRange,
    @required String format,
    @required ValueChanged<int> valueChanged,
  }) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical:8.0),
        height: widget.pickerTheme.pickerHeight,
        decoration: BoxDecoration(color: widget.pickerTheme.backgroundColor),
        child: CupertinoPicker.builder(
          backgroundColor: widget.pickerTheme.backgroundColor,
          scrollController: scrollCtrl,
          itemExtent: widget.pickerTheme.itemHeight,
          onSelectedItemChanged: valueChanged,
          childCount: valueRange.last - valueRange.first + 1,
          itemBuilder: (context, index) =>
              _renderDatePickerItemComponent(valueRange.first + index, format),
        ),
      ),
    );
  }

  Widget _renderDatePickerItemComponent(int value, String format) {
    return Container(
      height: widget.pickerTheme.itemHeight,
      alignment: Alignment.center,
      child: Text(
        formatDate(value, format),
        style:
        widget.pickerTheme.itemTextStyle ?? DATETIME_PICKER_ITEM_TEXT_STYLE,
      ),
    );
  }

  List<String> splitDateFormat(String dateFormat) {
    if (dateFormat == null || dateFormat.length == 0) {
      return [];
    }
    List<String> result = dateFormat.split(RegExp(DATE_FORMAT_SEPARATOR));
    return result;
  }

  String formatDate(
      int dateTime, String format) {
    if (format == null || format.length == 0) {
      return dateTime.toString();
    }
    String result = format;
    if (format.contains('y')) {
      result = _formatYear(dateTime, result);
    }
    if (format.contains('M')) {
      result = _formatMonth(dateTime, result);
    }
    if (format.contains('d')) {
      result = _formatDay(dateTime, result);
    }
    if (result == format) {
      return dateTime.toString();
    }
    return result;
  }

  /// format year text
  String _formatYear(
      int value, String format) {
    if (format.contains('yyyy')) {
      return format.replaceAll('yyyy', value.toString());
    } else if (format.contains('yy')) {
      return format.replaceAll('yy',
          value.toString().substring(max(0, value.toString().length - 2)));
    }
    return value.toString();
  }

  /// format month text
  String _formatMonth(
      int value, String format) {
    return _formatNumber(value, format, 'M');
  }

  /// format day text
  String _formatDay(
      int value, String format) {
    return _formatNumber(value, format, 'd');
  }

  String _formatNumber(int value, String format, String unit) {
    if (format.contains('$unit$unit')) {
      return format.replaceAll('$unit$unit', value.toString().padLeft(2, '0'));
    } else if (format.contains('$unit')) {
      return format.replaceAll('$unit', value.toString());
    }
    return value.toString();
  }


  /// change the selection of year picker
  void _changeYearSelection(int index) {
    int year = _yearRange.first + index;
    if (_currYear != year) {
      _currYear = year;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMonthSelection(int index) {
    int month = _monthRange.first + index;
    if (_currMonth != month) {
      _currMonth = month;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of day picker
  void _changeDaySelection(int index) {
    int dayOfMonth = _dayRange.first + index;
    if (_currDay != dayOfMonth) {
      _currDay = dayOfMonth;
      _onSelectedChange();
    }
  }

  /// change range of month and day
  void _changeDateRange() {
    if (_isChangeDateRange) {
      return;
    }
    _isChangeDateRange = true;

    List<int> monthRange = _calcMonthRange();
    bool monthRangeChanged = _monthRange.first != monthRange.first ||
        _monthRange.last != monthRange.last;
    if (monthRangeChanged) {
      // selected year changed
      _currMonth = max(min(_currMonth, monthRange.last), monthRange.first);
    }

    List<int> dayRange = _calcDayRange();
    bool dayRangeChanged =
        _dayRange.first != dayRange.first || _dayRange.last != dayRange.last;
    if (dayRangeChanged) {
      // day range changed, need limit the value of selected day
      if (!widget.onMonthChangeStartWithFirstDate) {
        max(min(_currDay, dayRange.last), dayRange.first);
      } else {
        _currDay = dayRange.first;
      }
    }

    setState(() {
      _monthRange = monthRange;
      _dayRange = dayRange;

      _valueRangeMap['M'] = monthRange;
      _valueRangeMap['d'] = dayRange;
    });

    if (monthRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMonth = _currMonth;
      _monthScrollCtrl.jumpToItem(monthRange.last - monthRange.first);
      if (currMonth < monthRange.last) {
        _monthScrollCtrl.jumpToItem(currMonth - monthRange.first);
      }
    }

    if (dayRangeChanged) {
      int currDay = _currDay;
      _dayScrollCtrl.jumpToItem(dayRange.last - dayRange.first);
      if (currDay < dayRange.last) {
        _dayScrollCtrl.jumpToItem(currDay - dayRange.first);
      }
    }

    _isChangeDateRange = false;
  }

  /// calculate the count of day in current month
  int _calcDayCountOfMonth() {
    if (_currMonth == 2) {
      return isLeapYear(_currYear) ? 29 : 28;
    } else if (_solarMonthsOf31Days.contains(_currMonth)) {
      return 31;
    }
    return 30;
  }

  /// whether or not is leap year
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    int yearIndex = _currYear - _minDateTime.year;
    int monthIndex = _currMonth - _monthRange.first;
    int dayIndex = _currDay - _dayRange.first;
    return [yearIndex, monthIndex, dayIndex];
  }

  /// calculate the range of year
  List<int> _calcYearRange() {
    return [_minDateTime.year, _maxDateTime.year];
  }

  /// calculate the range of month
  List<int> _calcMonthRange() {
    int minMonth = 1, maxMonth = 12;
    int minYear = _minDateTime.year;
    int maxYear = _maxDateTime.year;
    if (minYear == _currYear) {
      // selected minimum year, limit month range
      minMonth = _minDateTime.month;
    }
    if (maxYear == _currYear) {
      // selected maximum year, limit month range
      maxMonth = _maxDateTime.month;
    }
    return [minMonth, maxMonth];
  }

  /// calculate the range of day
  List<int> _calcDayRange({currMonth}) {
    int minDay = 1, maxDay = _calcDayCountOfMonth();
    int minYear = _minDateTime.year;
    int maxYear = _maxDateTime.year;
    int minMonth = _minDateTime.month;
    int maxMonth = _maxDateTime.month;
    if (currMonth == null) {
      currMonth = _currMonth;
    }
    if (minYear == _currYear && minMonth == currMonth) {
      // selected minimum year and month, limit day range
      minDay = _minDateTime.day;
    }
    if (maxYear == _currYear && maxMonth == currMonth) {
      // selected maximum year and month, limit day range
      maxDay = _maxDateTime.day;
    }
    return [minDay, maxDay];
  }
}



///日期选择顶部标题栏
class DatePickerTitleWidget extends StatelessWidget {
  DatePickerTitleWidget({
    Key key,
    this.pickerTheme,
    @required this.onCancel,
    @required this.onConfirm,
  }) : super(key: key);

  final DateTimePickerTheme pickerTheme;
  final DateVoidCallback onCancel, onConfirm;

  @override
  Widget build(BuildContext context) {
    if (pickerTheme.title != null) {
      return pickerTheme.title;
    }
    return Container(
      height: pickerTheme.titleHeight,
      decoration: BoxDecoration(color: pickerTheme.backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _renderCancelWidget(context),
          _renderConfirmWidget(context),
        ],
      ),
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    if (isCustomTitleWidget()) {
      // has custom title button widget
      if (pickerTheme.cancel == null) {
        return Offstage();
      }
    }

    Widget cancelWidget = pickerTheme.cancel;
    if (cancelWidget == null) {
      TextStyle textStyle = pickerTheme.cancelTextStyle ??
          TextStyle(
            color: Theme.of(context).unselectedWidgetColor,
            fontSize: 16.0,
          );
      cancelWidget = Text(
        '取消',
        style: textStyle,
      );
    }

    return Container(
      height: pickerTheme.titleHeight,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: cancelWidget,
        onPressed: () => this.onCancel(),
      ),
    );
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    if (isCustomTitleWidget()) {
      // has custom title button widget
      if (pickerTheme.confirm == null) {
        return Offstage();
      }
    }

    Widget confirmWidget = pickerTheme.confirm;
    if (confirmWidget == null) {
      TextStyle textStyle = pickerTheme.confirmTextStyle ??
          TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16.0,
          );
      confirmWidget = Text(
        '确定',
        style: textStyle,
      );
    }

    return Container(
      height: pickerTheme.titleHeight,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: confirmWidget,
        onPressed: () => this.onConfirm(),
      ),
    );
  }

  bool isCustomTitleWidget() {
    return pickerTheme.cancel != null ||
        pickerTheme.confirm != null ||
        pickerTheme.title != null;
  }
}
