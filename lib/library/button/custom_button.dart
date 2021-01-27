
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget/library/theme/theme_widget.dart';

class ButtonConfig{
 final double fontSize;
 final Color fontColor;
 final Color bgColor;
 final double height;
 final double width;
 final double iconSize;
 final double borderSize;
 final BorderRadius radius;

  ButtonConfig({this.fontSize=18.0, 
    this.fontColor,
    this.bgColor,
    this.height=45.0,
    this.width, 
    this.iconSize=8.0,
    this.borderSize=.5,
    this.radius=const BorderRadius.all(Radius.circular(4))});
}

// 颜色类型
enum ButtonType {
  normal,
  primary,
}

class CustomButton extends StatefulWidget {
  // 内容
  final dynamic child;
  // 禁用
  final bool disabled;
  // 点击回调
  final Function onClick;
  // loading
  final bool loading;
  // 空心
  final bool hollow;
  // 按钮样式类型
  final ButtonConfig config;
  // 主题
  final ButtonType theme;

  CustomButton(
      this.child,{
        this.config ,
        this.onClick,
        this.hollow = false,
        this.theme = ButtonType.normal,
        this.disabled = false,
        this.loading = false,
      });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  // 主题
  List<Map<String, Color>> themeConfig;
  // 按钮主题
  Map<String, Color> theme;
  ButtonConfig _config=ButtonConfig(
      fontSize: 18.0,
      height: 45.0,
      iconSize: 8.0,
      borderSize: .5,
      radius: const BorderRadius.all(Radius.circular(4))
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final MainTheme theme = ThemeWidget.getTheme(context);
    // 按钮主题
    themeConfig = [
      // 默认
      {
        'backgroundColor': widget?.config?.bgColor??theme.defaultBackgroundColor,
        'fontColor': widget?.config?.fontColor??Colors.black,
        'disabledBackgroundColor': Color(0xfff7f7f7),
        'borderColor': theme.defaultBorderColor,
        'hollowColor': Color(0xff353535)
      },
      // primary
      {
        'backgroundColor': widget?.config?.bgColor??theme.primaryColor,
        'fontColor': widget?.config?.fontColor??Colors.white,
        'disabledBackgroundColor': theme.primaryColorDisabled,
        'borderColor': theme.primaryColor,
        'hollowColor': theme.primaryColor
      },
    ];

    final themeConf = themeConfig[widget.theme.index];
    // 判断是否空心
    if (widget.hollow) {
      this.theme = {
        'backgroundColor': Colors.transparent,
        'fontColor': themeConf['hollowColor'],
        'disabledBackgroundColor': null,
        'borderColor': themeConf['hollowColor']
      };
    } else {
      this.theme = themeConf;
    }
    if(widget.config!=null){
      _config=widget.config;
    }
  }

  // 按钮点击
  onClick() {
    if (widget.onClick is Function) {
      widget.onClick();
    }
  }

  // 渲染按钮内容
  Widget renderChild(content) {
    // size
    // 是否禁用状态
    final bool disabled = widget.loading || widget.disabled;
    Widget child;
    if (content is String) {
      child = Text(content);
    } else {
      child = content;
    }

    // 内容
    List<Widget> children = [
      DefaultTextStyle(
          style: TextStyle(
              fontSize: _config.fontSize,
              color: theme['fontColor']
          ),
          child: child
      )
    ];

    if (widget.loading) {
      final Widget icon = Padding(
          padding: EdgeInsets.only(right: 5),
          child:CupertinoActivityIndicator(radius: _config.iconSize,),
      );
      children.insert(0, icon);
    }

    return Opacity(
        opacity: disabled ? 0.7 : 1,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize:  MainAxisSize.max,
            children: children
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // 是否禁用状态
    final bool disabled = widget.loading || widget.disabled;
    // 圆角
    final BorderRadius borderRadius = _config.radius;
    // 按钮
    final Widget button = Container(
        height: _config.height,
        width: _config.width,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: disabled ? theme['disabledBackgroundColor'] : null,
            borderRadius: borderRadius,
            // 空心或者默认按钮才添加边框
            border: widget.hollow || widget.theme == ButtonType.normal ? Border.all(
                width: _config.borderSize,
                color: theme['borderColor']
            ) : null
        ),
        child: renderChild(widget.child)
    );

    // 禁用状态
    if (disabled) {
      return button;
    }

    return Material(
        borderRadius: borderRadius,
        color: theme['backgroundColor'],
        child: InkWell(
            onTap: onClick,
            borderRadius: borderRadius,
            child: button
        )
    );
  }
}
