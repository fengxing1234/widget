import 'package:flutter/material.dart';

class DateSelectProvider extends ChangeNotifier{
  String dateTime='';
  changeDate(String date){
    dateTime=date;
    notifyListeners();
  }
}