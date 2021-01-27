import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget/utils/load_image_utils.dart';

typedef ExpansionCallback = void Function(bool isExpanded);

///自定义扩展布局
class SurveyExpansionView extends StatefulWidget{
  /// 一级标题
  final Widget title;
  /// 二级标题
  final Widget subTitle;
  /// 下拉扩展的布局
  final Widget expansionList;
  /// 回调方法
  final ExpansionCallback callback;
  /// 间距
  final EdgeInsetsGeometry padding;
  /// 是否展示分割线
  final bool isShow;
  /// 是否展示 收起为最左边
  final bool isShowLeft;
  /// 是否展示收起为中间
  final bool isShowCenter;
  /// 是否展示title为最底部
  final bool isBottom;
  /// 是否展示文字
  final bool isShowText;
  /// 是否展示 展开/收起
  final List<String> subTitleList;

  const SurveyExpansionView(
      {Key key,
        this.title,
        this.subTitle,
        this.expansionList,
        this.callback,
        this.padding,
        this.isShow = true,
        this.subTitleList,
        this.isShowLeft = false,
        this.isShowCenter = false,
        this.isBottom = false,
        this.isShowText = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextExpansionView();
  }
}

class _TextExpansionView extends State<SurveyExpansionView>
    with SingleTickerProviderStateMixin {
  /// 展开/关闭
  bool _isOpen = true;
  String subTitleStr;

  @override
  Widget build(BuildContext context) {
    if(widget.isBottom){
      return Column(
        children: <Widget>[
          _buildAnimatedCrossFade(),
          GestureDetector(
            child: widget.isShowText ? _buildPanelTitleShowText() : _buildPanelTitle(),
            onTap: () {
              _changeState();
            },
          ),
        ],
      );
    }
    return Column(
      children: [
        GestureDetector(
          child: widget.isShowText ? _buildPanelTitleShowText() : _buildPanelTitle(),
          onTap: () {
            _changeState();
          },
        ),
        _buildAnimatedCrossFade(),
      ],
    );
  }

  @override
  void initState() {
    if (widget.subTitleList != null) {
      subTitleStr = widget.subTitleList[0] ?? '';
    }
    super.initState();
  }

  /// 改变是否可扩展的状态
  _changeState() {
    setState(() => _isOpen = _isOpen == false ? true : false);
    if(widget.subTitleList != null){
      if (widget.subTitleList.length < 2) {
        return;
      }
      if (_isOpen) {
        subTitleStr = widget.subTitleList[0];
      } else {
        subTitleStr = widget.subTitleList[1];
      }
    }
  }

  _buildPanelTitle(){
    return Container(
      padding: widget.padding,
      color: Color(0xFFFFFFFF),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 14, bottom: 14),
            child: Column(
              children: [
                widget.title,
                SizedBox(height: 4),
                widget.isShow ? Divider(
                    height: 1, color: Color(0xFFEAEAEA)) : SizedBox.shrink(),
                widget.isShow ? SizedBox(height: 10) : SizedBox.shrink(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.title ?? SizedBox.shrink(),
                    Padding(padding: EdgeInsets.only(left: 2)),
                    loadAssetImage(
                        _isOpen ? 'icon_bottom_new' : 'icon_top',
                        width: 9,
                        height: 9,
                        fit: BoxFit.cover),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Color(0xFFEAEAEA)),
        ],
      ),
    );
  }

  /// 展示标题
  _buildPanelTitleShowText(){
    return Container(
      padding: widget.padding,
      color: Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 14, bottom: 14),
            child: Row(
              mainAxisAlignment: widget.isShowCenter? MainAxisAlignment.center :
              widget.isShowLeft
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: <Widget>[
                widget.title,
                Row(
                  children: <Widget>[
                    widget.subTitle ?? Container(),
                    widget.subTitleList == null ||
                        widget.subTitleList.length < 2
                        ? Container()
                        : Text(subTitleStr,
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF999999))),
                    Padding(padding: EdgeInsets.only(left: 2)),
                    loadAssetImage(
                        _isOpen ? 'icon_bottom_new' : 'icon_top',
                        width: 9,
                        height: 9,
                        fit: BoxFit.cover),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Color(0xFFEAEAEA)),
        ],
      ),
    );
  }

  /// 扩展布局
  _buildAnimatedCrossFade() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      firstChild: Container(
        height: 0,
      ),
      secondChild: widget.expansionList,
      crossFadeState:
      _isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}