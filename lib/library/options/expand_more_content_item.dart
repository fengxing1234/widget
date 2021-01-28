import 'package:flutter/material.dart';
import 'package:widget/library/options/base_content_item.dart';
import 'package:widget/library/options/expand_more_model.dart';

typedef Future<String> ExpandTop(List<ExpandModel> list);

class ExpandMoreContentItem extends BaseContentItem{
  final List<ExpandModel> models;

  ///默认选中按钮
  final int defaultIndex;

  ///默认选中按钮
  final ExpandModel defaultExpandModel;

  ///默认选中按钮可以有多个
  final List<int> indexList;

  ///默认显示几个
  final int showCount;

  ///单选还是多选
  final bool single;

  ///选择类型
  final ExpandTop expandTop;

  ///展开还是收起状态
  final bool isExpand;
  final bool isFirstExpandTop;

  ///是否设置选中效果为第一个
  final bool isSetFirst;

  ExpandMoreContentItem({
    Key key,
    this.isExpand,
    this.models,
    this.defaultIndex,
    this.indexList,
    this.showCount,
    this.single,
    this.defaultExpandModel,
    this.expandTop,
    this.isSetFirst = true,
    this.isFirstExpandTop=false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ExpandButtonItem(
        models: models,
        defaultExpandModel: defaultExpandModel,
        defaultIndex: defaultIndex ?? -1,
        showCount: showCount,
        single: single ?? true,
        expandTop: expandTop,
        isExpand: isExpand,
        isSetFirst: isSetFirst,
        isFirstExpandTop: isFirstExpandTop,
      ),
    );
  }
}

///按钮的样式，需要状态改变
class ExpandButtonItem extends StatefulWidget {
  final List<ExpandModel> models;

  final List<Map> modelMap;

  ///默认选中按钮
  final int defaultIndex;

  ///默认选中按钮
  final ExpandModel defaultExpandModel;

  ///展开还是收起状态
  final bool isExpand;

  ///默认选中按钮可以有多个
  final List<int> indexList;

  ///默认显示几个
  final int showCount;

  ///单选还是多选
  final bool single;

  ///选择类型
  final ExpandTop expandTop;
  final bool isFirstExpandTop;
  final bool isSetFirst;
  final WrapAlignment align;
  final EdgeInsetsGeometry padding;

  const ExpandButtonItem({
    Key key,
    this.models,
    this.defaultIndex: -1,
    this.indexList,
    this.showCount,
    this.single: true,
    this.defaultExpandModel,
    this.expandTop,
    this.modelMap,
    this.isExpand,
    this.isFirstExpandTop=false,
    this.isSetFirst=false,
    this.align=WrapAlignment.start,
    this.padding=const EdgeInsets.all(8),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExpandButtonItemState();
}

class ExpandButtonItemState extends State<ExpandButtonItem>
    with AutomaticKeepAliveClientMixin {
  List<ExpandModel> selectedList = List();

  @override
  void initState() {
    super.initState();
    print('ExpandButtonItem 初始化 initState');
    if (widget.defaultExpandModel != null) {
      selectedList.add(widget.defaultExpandModel);
    }
    if (!(widget.defaultIndex < 0)) {
      selectedList.add(widget.models[widget.defaultIndex]);
    }
    if(!widget.isFirstExpandTop) {
      if (widget.expandTop != null) {
        widget.expandTop(selectedList);
      }
    }
  }

  @override
  void didUpdateWidget(ExpandButtonItem oldWidget) {
    /// 组件更新状态后调用
    if(oldWidget.defaultIndex!=widget.defaultIndex){
      debugPrint('defaultIndex:${widget.defaultIndex}');
      if(widget.single){
        if (widget.defaultIndex >= 0) {
          selectedList.clear();
          selectedList.add(widget.models[widget.defaultIndex]);
        }
      }
    }
    if (selectedList.isNotEmpty && widget.single) {
      var model = widget.models.firstWhere((model) {
        return model.name == selectedList[0].name &&
            model.value == selectedList[0].value;
      });
      int index = widget.models.indexOf(model);
      if (index < 0) {
        return;
      }
      if(widget.isSetFirst){
        widget.models.removeAt(index);
        widget.models.insert(0, selectedList[0]);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Wrap(
      //主轴方向子 widget 的间距
        spacing: 15.0,
        //纵轴方向的间距
        runSpacing: 7.5,
        //纵轴方向的对齐方式
        runAlignment: WrapAlignment.start,
        alignment: widget.align,
        children: widget.models
            .map((model) {
          return _buildButtonItem(
              context, widget.models.indexOf(model), model);
        }).toList().take(widget.isExpand ? widget.models.length : widget.showCount ?? 1).toList());
  }

  ///构建每一个子项的布局
  Widget _buildButtonItem(context, index, ExpandModel model) {
    return InkWell(
      onTap: () {
        if (selectedList.contains(model)) {
          if(!widget.single){
            selectedList.remove(model);
          }
        } else {
          selectedList.add(model);
        }
        ///单选多选逻辑
        if (widget.single && selectedList.length > 1) {
          selectedList.removeAt(0);
        }
        setState(() {});
        if (widget.expandTop != null) {
          widget.expandTop(selectedList).then((s) {
            print(s);
          });
        }
      },
      child: Container(
        decoration: checkSelect(model)
            ? BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: Color(0xFFFFECEC),
          border: Border.all(color: Color(0xFFFF4848), width: 1),
        )
            : BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border: Border.all(color: Color(0xFFCCCCCC), width: 1),
        ),
        padding: widget.padding,
        child: Text(
          model.name,
          style: Theme.of(context).textTheme.caption.copyWith(
              color: checkSelect(model)
                  ? Color(0xFFFF4848)
                  : Color(0xFF666666)),
        ),
      ),
    );
  }

  /// 子项列表是否选中状态
  bool checkSelect(ExpandModel model) {
    if (selectedList.length == 0) {
      return false;
    }
    return selectedList.any((e) {
      return e.name == model.name && e.value == model.value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('ExpandButtonItem 销毁 dispose');
  }

  @override
  bool get wantKeepAlive => true;
}