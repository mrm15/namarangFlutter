import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // رنگ اصلی برند
  static const primary = Color(0xFF304968);

  // رنگ دوم برند (روشن‌تر، برای گرادینت و لهجه‌های ظریف)
  static const secondary = Color(0xFF5B7A9E);

  static const background = Color(0xFFFFFFFF);

  static const surface = Color(0xFFFFFFFF);

  static const textPrimary = Color(0xFF212121);

  static const textSecondary = Color(0xFF757575);

  static const border = Color(0xFFE0E0E0);

  static const error = Color(0xFFD32F2F);

  // گرادینت برند (طیف سرمه‌ای، برای پس‌زمینه و دکمه‌ها)
  static const List<Color> brandGradient = [
    Color(0xFF4A6C93),
    Color(0xFF304968),
    Color(0xFF1F3247),
  ];
}
