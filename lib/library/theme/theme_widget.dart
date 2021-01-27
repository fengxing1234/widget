import 'package:flutter/material.dart';


const Color _primaryColor = Color(0xFFFF5A5A);
const Color _primaryColorDisabled = Color(0x80FF3B3B);
const Color _warnColor = Color(0xffE64340);
const Color _warnColorDisabled = Color(0xffEC8B89);
const Color _defaultBackgroundColor = Color(0xfff8f8f8);
const Color _defaultBorderColor = Color(0xffd8d8d8);
const Color _maskColor = Color.fromRGBO(17, 17, 17, 0.6);
const Color _textColor=Color(0xFF333333);

final _defaultTheme = MainTheme();
final _defaultConfig = MainConfig();

// 主题
class MainTheme {
  // 主色
  final Color primaryColor;
  // 主色禁用
  final Color primaryColorDisabled;
  // 警告色
  final Color warnColor;
  // 警告色禁用
  final Color warnColorDisabled;
  // 默认背景色
  final Color defaultBackgroundColor;
  // 默认边框色
  final Color defaultBorderColor;
  // 遮罩层颜色
  final Color maskColor;
  // 文字颜色
  final Color textColor;

  MainTheme({
    this.primaryColor = _primaryColor,
    this.primaryColorDisabled = _primaryColorDisabled,
    this.warnColor = _warnColor,
    this.warnColorDisabled = _warnColorDisabled,
    this.defaultBackgroundColor = _defaultBackgroundColor,
    this.defaultBorderColor = _defaultBorderColor,
    this.maskColor = _maskColor,
    this.textColor=_textColor,
  });
}

// 配置
class MainConfig {
  final String successText;
  final Duration successDuration;
  final bool successBackButtonClose;
  final String loadingText;
  final bool loadingBackButtonClose;
  final Alignment toastAlignment;

  MainConfig({this.successText = '加载成功',
    this.successDuration =  const Duration(seconds: 3),
    this.successBackButtonClose = true,
    this.loadingText = '加载中...',
    this.loadingBackButtonClose = false,
    this.toastAlignment = const Alignment(0.0, -0.2)});
}
///主题控制组件
class ThemeWidget extends InheritedWidget{

  final MainTheme theme;
  final MainConfig config;

  ThemeWidget({
    Key key,
    this.theme,
    this.config,
    Widget child
  }) : super(key: key, child: child);

  static ThemeWidget of(BuildContext context) {
    var widget = context.dependOnInheritedWidgetOfExactType<ThemeWidget>();
    if(widget is ThemeWidget){
      return widget;
    }
    return ThemeWidget(
      theme: MainTheme(),
      config: MainConfig(),
    );
  }

  // 获取主题配置
  static MainTheme getTheme(BuildContext context) {
    final ThemeWidget themeWidget = ThemeWidget.of(context);
    return themeWidget == null || themeWidget.theme == null ? _defaultTheme : themeWidget.theme;
  }

  // 获取全局配置
  static MainConfig getConfig(BuildContext context) {
    final ThemeWidget themeWidget = ThemeWidget.of(context);
    return themeWidget == null || themeWidget.config == null ? _defaultConfig : themeWidget.config;
  }

  @override
  bool updateShouldNotify(covariant ThemeWidget oldWidget) {
    return true;
  }

}