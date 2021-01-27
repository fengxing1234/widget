import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  TitleWidget(this.title);
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 8),
            child: Text(title, style: TextStyle(
                fontSize: 16
            ))
        )
    );
  }
}