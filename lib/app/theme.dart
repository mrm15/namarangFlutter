import 'package:flutter/material.dart';
import 'package:namarang/core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
    );
  }
}
