import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Function debounce(
  Function func, [
  Duration delay = const Duration(milliseconds: 100),
]) {
  Timer timer;
  Function target = () {
    if (timer?.isActive ?? false) timer?.cancel();
    timer = Timer(delay, () {
      func?.call();
    });
  };
  return target;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor, String opacity) {
    assert(hexColor != null);
    hexColor = hexColor.toUpperCase().replaceAll("#", "").replaceAll('0X', '');
    if (hexColor.length == 6)
      hexColor = opacity + hexColor;
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor,{String opacity="FF"}) : super(_getColorFromHex(hexColor, opacity));
}
