import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:widget/library/theme/theme_widget.dart';

/// 开关组件。支持设置提示、滑块装饰、阴影。
// ignore: must_be_immutable
class SwitchWidget extends StatefulWidget {
  /// 是否处于打开状态。默认 false。
  ///
  bool open;

  /// 当开关状态发生改变时，会回调该函数。
  ///
  ValueChanged<bool> onChanged;

  /// 宽度。默认 59.23
  ///
  double width;

  /// 高度。默认会根据 [width] 进行计算
  ///
  double height;

  /// 滑块与边缘的间距
  ///
  double offset;

  /// 打开状态的提示样式
  ///
  Widget openChild;

  /// 关闭状态的提示样式
  ///
  Widget closeChild;

  /// 提示与边缘的间距
  ///
  double childOffset;

  /// 关闭状态下的背景色
  ///
  Color color;

  /// 打开状态下的背景色
  ///
  Color openColor;

  /// 滑块颜色
  ///
  Color sliderColor;

  /// 滑块中的组件。超过范围会被剪裁。
  ///
  Widget sliderChild;

  /// 是否可用
  ///
  bool enable;

  /// 设置组件阴影颜色
  ///
  Color shadowColor;

  /// 设置组件阴影偏移
  ///
  Offset shadowOffset;

  /// 设置组件高斯与阴影形状卷积的标准偏差。
  ///
  double shadowBlur;

  SwitchWidget({
    Key key,
    @required this.onChanged,
    this.open = false,
    this.width = 59.23,
    this.height,
    this.offset,
    this.childOffset,
    this.closeChild,
    this.openChild,
    this.color,
    this.openColor,
    this.sliderColor,
    this.sliderChild,
    this.enable = true,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlur = 0.0,
  })  : assert(open != null && onChanged != null,
  "open and onChanged can't be None!"),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SwitchWidgetState();
  }
}

class _SwitchWidgetState extends State<SwitchWidget> {
  double fixOffset;
  bool dragging = false;
  double dragDxW = 10.0;

  @override
  void initState() {
    super.initState();
    fixOffset = widget.open
        ? widget.width -
        (widget.offset ??
            2.0 / 36.0 * ((widget.height ?? widget.width * 0.608))) *
            2.0 -
        (widget.height ?? widget.width * 0.608) * (32.52 / 36.0)
        : 0;
  }

  @override
  void didUpdateWidget(SwitchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    fixOffset = widget.open
        ? widget.width -
        (widget.offset ??
            2.0 / 36.0 * ((widget.height ?? widget.width * 0.608))) *
            2.0 -
        (widget.height ?? widget.width * 0.608) * (32.52 / 36.0)
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.height ?? widget.width * 0.608;
    double circleSize = (height * (32.52 / 36.0));
    widget.offset = widget.offset ?? 2.0 / 36.0 * height;
    double childOffset = widget.childOffset ?? height / 5.0;
    widget.color = widget.color ?? Color(0xffcccccc);
    widget.openColor = widget.openColor ?? ThemeWidget.getTheme(context).primaryColor;

    List<Widget> children = [];

    /// 背景
    var showShadow = widget.shadowColor != null && widget.shadowBlur != 0;
    var background = AnimatedContainer(
      duration: Duration(milliseconds: 350),
      decoration: BoxDecoration(
        color: (widget.open ? widget.openColor : widget.color) ?? widget.color,
        borderRadius: BorderRadius.all(Radius.circular(height / 2.0)),
        boxShadow: showShadow
            ? [
          BoxShadow(
            color: widget.shadowColor,
            offset: widget.shadowOffset ?? Offset(0, 0),
            blurRadius: widget.shadowBlur,
          )
        ]
            : null,
      ),
      child: Container(
        width: widget.width,
        height: height,
      ),
    );
    children.add(background);

    var showChild = widget.open ? widget.openChild : widget.closeChild;
    if (showChild != null) {
      showChild = Positioned(
        left: widget.open ? childOffset : null,
        right: widget.open ? null : childOffset,
        child: showChild,
      );
      children.add(showChild);
    }

    /// 滑块
    var slider = AnimatedContainer(
      margin: EdgeInsets.fromLTRB(widget.offset + fixOffset, 0, 0, 0),
      duration: Duration(milliseconds: 200),
      width: circleSize + (dragging ? dragDxW : 0.0),
      child: Container(
        height: circleSize,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.sliderColor ?? Color(0xffffffff),
            borderRadius: BorderRadius.all(Radius.circular(circleSize / 2.0))),
        child: widget.sliderChild,
      ),
    );
    children.add(slider);

    if (!widget.enable) {
      var disableMask = Opacity(
        opacity: 0.6,
        child: Container(
          width: widget.width,
          height: height,
          decoration: BoxDecoration(
              color: Color(0xfff1f1f1),
              borderRadius: BorderRadius.all(Radius.circular(height / 2.0))),
        ),
      );
      children.add(disableMask);
    }

    return GestureDetector(
      onTap: widget.enable ? _handleOnTap : null,
      onHorizontalDragEnd: widget.enable ? _handleOnHorizontalDragEnd : null,
      onHorizontalDragUpdate:
      widget.enable ? _handleOnHorizontalDragUpdate : null,
      onHorizontalDragCancel: widget.enable ? _handleDragCancel : null,
      onHorizontalDragStart: widget.enable ? _handleDragStart : null,
      child: Container(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: children,
        ),
      ),
    );
  }

  void _handleOnTap() {
    setState(() {
      widget.open = !widget.open;
      double height = widget.height ?? widget.width * 0.608;
      double circleSize = (height * (32.52 / 36.0));
      if (widget.open) {
        fixOffset = widget.width - widget.offset - circleSize - widget.offset;
      } else {
        fixOffset = 0;
      }
      widget.onChanged(widget.open);
    });
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      dragging = true;
    });
  }

  void _handleOnHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      double height = widget.height ?? widget.width * 0.608;
      double circleSize = (height * (32.52 / 36.0));
      fixOffset = fixOffset + details.delta.dx;
      if (fixOffset < 0) {
        fixOffset = 0;
      } else if (fixOffset >
          widget.width -
              widget.offset -
              circleSize -
              (dragging ? dragDxW : 0.0) -
              widget.offset) {
        fixOffset = widget.width -
            widget.offset -
            circleSize -
            (dragging ? dragDxW : 0.0) -
            widget.offset;
      }
    });
  }

  void _handleOnHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      dragging = false;
      double height = widget.height ?? widget.width * 0.608;
      double circleSize = (height * (32.52 / 36.0));
      double center = (widget.width -
          widget.offset -
          circleSize -
          (dragging ? dragDxW : 0.0) -
          widget.offset) /
          2;
      bool cacheValue = widget.open;
      if (fixOffset < center) {
        fixOffset = 0;
        widget.open = false;
      } else {
        fixOffset = center * 2;
        widget.open = true;
      }
      if (cacheValue != widget.open) {
        widget.onChanged(widget.open);
      }
    });
  }

  void _handleDragCancel() {
    setState(() {
      dragging = false;
    });
  }
}
