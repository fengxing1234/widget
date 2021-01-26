import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:widget/assets_utils.dart';

/// 加载本地资源图片
Widget loadAssetImage(String name, {double width, double height, BoxFit fit,BlendMode mode,Color color}) {
  return Image.asset(
    AssetsUtils.getImgPath(name),
    height: height,
    width: width,
    fit: fit,
    colorBlendMode: mode,
    color: color,
  );
}

Future<String> image2Base64(String path) async {
  File file = new File(path);
  List<int> imageBytes = await file.readAsBytes();
  print('imageBytes = ${imageBytes.length}');
  return base64Encode(imageBytes);
}
