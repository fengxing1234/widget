import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseEditView extends StatefulWidget {
  ///标题 文字 例如 领款人性质
  final String titleName;

  ///默认文字
  final String hint;

  ///文本控制器
  final TextEditingController controllerValue;

  ///是否可编辑文本
  final bool enabled;

  ///input输入内容
  final bool isNum;

  ///input输入内容大写
  final bool toUp;

  ///input输入内容只为数字 不包括小数点
  ///需要先设置  isNum = true
  final bool isOnlyNum;
  final bool isNoLetter;

  ///input输入内容长度
  final int length;

  ///input输入内容focusNode
  final FocusNode focusNode;

  ///遮罩层
  final bool isLayer;

  ///限制只能输入字母和数字
  final bool numberLetter;

  ///标题字体风格
  final TextStyle titleNameStyle;

  ///编辑内容字体风格
  final TextStyle editTextStyle;

  ///编辑框默认文字字体风格
  final TextStyle hintTextStyle;

  ///输入框背景样式：边框宽度，颜色，圆角
  final BoxDecoration decoration;
  final int maxLines;

  ///回调函数 回调选择结果
  final Function onSelect;

  final cursorWidth;

  const BaseEditView(
      {Key key,
      this.titleName,
      this.hint,
      this.controllerValue,
      this.enabled,
      this.isNum,
      this.toUp,
      this.isOnlyNum,
      this.isNoLetter,
      this.length,
      this.focusNode,
      this.isLayer,
      this.numberLetter,
      this.titleNameStyle,
      this.onSelect,
      this.editTextStyle,
      this.cursorWidth,
      this.maxLines,
      this.hintTextStyle,
      this.decoration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BaseEditView();
  }
}

class _BaseEditView extends State<BaseEditView> {
  @override
  Widget build(BuildContext context) {
    return _buildEditWidget();
  }

  _buildEditWidget() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.titleName == null ? Container() : _buildSubTitleItem(),
              _buildInputText()
            ],
          ),
        ),
        widget.isLayer == null || !widget.isLayer
            ? Container()
            : Positioned(
                left: 15,
                right: 15,
                top: 10,
                bottom: 10,
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                ))
      ],
    );
  }

  _buildSubTitleItem() {
    return
        ///标题
        RichText(
      text: TextSpan(children: [
        TextSpan(
            text: widget.titleName,
            style: widget.titleNameStyle == null
                ? TextStyle(color: Color(0xFF151515), fontSize: 14)
                : widget.titleNameStyle),
      ]),
    );
  }

  _buildInputText() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: widget.decoration == null
            ? BoxDecoration(
                border: Border.all(
                  color: Color(0xFFCCCCCC),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(3.0),
              )
            : widget.decoration,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    textCapitalization: widget.toUp == null || !widget.toUp
                        ? TextCapitalization.sentences
                        : TextCapitalization.characters,
                    textAlign: TextAlign.left,
                    textAlignVertical: TextAlignVertical.center,
                    controller: widget.controllerValue,
                    enabled: widget.enabled,
                    onChanged: (value) {
                      if (value.length <= widget.length) {
                        widget.onSelect(value);
                      }
                      setState(() {});
                    },
                    focusNode: widget.focusNode,
                    style: widget.editTextStyle != null
                        ? widget.editTextStyle
                        : TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFB9769),
                            textBaseline: TextBaseline.alphabetic),
                    cursorWidth:
                        widget.cursorWidth == null || widget.cursorWidth == 0
                            ? 1
                            : widget.cursorWidth,
                    cursorColor: Color(0xFFFF5A5A),
                    maxLines: widget.maxLines,
                    minLines: 1,
                    showCursor: true,
                    // keyboardType: ,
                    textInputAction: TextInputAction.unspecified,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 1),
                      isDense: true,
                      hintText: widget.hint,
                      hintStyle: widget.hintTextStyle == null
                          ? TextStyle(
                              fontSize: 14,
                              color: Color(0x99666666),
                              textBaseline: TextBaseline.alphabetic)
                          : widget.hintTextStyle,
//                              contentPadding: EdgeInsets.only(top: 2),
                      border: InputBorder.none,
                    ),
                    inputFormatters: widget.numberLetter == null ||
                            !widget.numberLetter
                        ? <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(widget.length),

                            ///限制长度
                            widget.isNum == null || !widget.isNum
                                ? BlacklistingTextInputFormatter(RegExp("[]"))
                                // ignore: deprecated_member_use
                                : (widget.isOnlyNum
                                    ? WhitelistingTextInputFormatter.digitsOnly
                                    : widget.isNoLetter
                                        // ignore: deprecated_member_use
                                        ? WhitelistingTextInputFormatter(
                                            RegExp("[0-9.]"))
                                        // ignore: deprecated_member_use
                                        : WhitelistingTextInputFormatter(
                                            RegExp("[0-9.-]"))),
                            LengthLimitingTextInputFormatter(widget.length)
                          ]
                        : [
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter(
                                RegExp("[a-zA-Z0-9]")),
                            LengthLimitingTextInputFormatter(widget.length),
                          ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
