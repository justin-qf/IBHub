import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextItem {
  RxDouble posX;
  RxDouble posY;
  RxString content;
  RxDouble fontSize;
  Rx<Alignment> alignment;
  Rx<Color> textColor;
  RxBool isBold;
  RxBool isItalic;

  TextItem({
    required double x,
    required double y,
    required String text,
    required double size,
    Alignment align = Alignment.center,
    Color color = Colors.black,
    bool bold = false,
    bool italic = false,
  })  : posX = RxDouble(x),
        posY = RxDouble(y),
        content = RxString(text),
        fontSize = RxDouble(size),
        alignment = Rx<Alignment>(align),
        textColor = Rx<Color>(color),
        isBold = RxBool(bold),
        isItalic = RxBool(italic);
}