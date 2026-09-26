import 'package:flutter/material.dart';
import 'package:rawg/core/theme/app_palette.dart';

abstract final class AppFont {
  static const String fontFamily = 'SFProDisplay';

  static TextStyle style({double fontSize = 14, Color color = AppPalette.white, FontWeight fontWeight = FontWeight.normal}) => TextStyle(color: color, fontFamily: fontFamily, fontSize: fontSize, fontWeight: fontWeight, height: 1.25);
}
