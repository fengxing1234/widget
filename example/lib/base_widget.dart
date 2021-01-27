import 'package:flutter/material.dart';

import 'markdown/code_page.dart';


///用于组件展示效果的页面
class BaseWidget extends StatefulWidget {
  final String title;
  final Widget widget;
  final String codePath;

  BaseWidget(this.title, this.codePath, this.widget);

  @override
  _BaseWidgetState createState() {
    return _BaseWidgetState();
  }
}

class _BaseWidgetState extends State<BaseWidget> {

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final contentHeight = mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom - kToolbarHeight;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, '');
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff8f8f8),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black54,
            onPressed: () {
              Navigator.maybePop(context, null);
            },
          ),
          brightness: Brightness.light,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.code),
              color: Colors.black54,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CodePage(widget.codePath + '.dart'),
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          color: Color(0xfff8f8f8),
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          height: contentHeight,
          child: widget.widget,
        ),
      ),
    );
  }
}
