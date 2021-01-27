import 'dart:core';

class ExpandModelList {
  List<ExpandModel> list;

  ExpandModelList({this.list});

  factory ExpandModelList.formJson(List<dynamic> listMap) {
    List<ExpandModel> list = new List<ExpandModel>();
    list = listMap.map((map) => ExpandModel.formJson(map)).toList();
    return ExpandModelList(list: list);
  }
}

class ExpandModel {
  String name;
  String value;
  String id;

  ExpandModel({
    this.name,
    this.value,
    this.id,
  });

  factory ExpandModel.formJson(Map<dynamic, dynamic> map) {
    return ExpandModel(
      name: map['name'],
      value: map['value'],
      id:map['id'],
    );
  }
}
