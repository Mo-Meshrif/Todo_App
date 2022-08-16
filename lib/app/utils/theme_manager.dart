import 'package:flutter/material.dart';
import 'color_manager.dart';

class ThemeManager {
  static ThemeData lightTheme() {
    return ThemeData(
      // main colors
      primaryColor: ColorManager.primary,
      hintColor: ColorManager.swatch,
      backgroundColor: ColorManager.background,
      // app bar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        color: ColorManager.primary,
      ),
    );
  }
}
