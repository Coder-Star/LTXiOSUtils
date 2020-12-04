import 'dart:ui';

import 'package:flutter/material.dart';

/// 颜色扩展
extension ColorExtension on Color {
  /// Color转为MaterialColor
  MaterialColor toMaterialColor() {
    var strengths = <double>[.05];
    var swatch = <int, Color>{};
    final r = red;
    final g = green;
    final b = blue;

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(value, swatch);
  }

  /// 转为hex值字符串
  String toHex() {
    // ignore: lines_longer_than_80_chars
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// hex值转Color
  static Color hexToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
