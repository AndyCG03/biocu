import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headlineLarge,
      titleMedium: AppTextStyles.titleMedium,
      bodyMedium: AppTextStyles.bodyText,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
    ),
  );

  // Opcional: tema oscuro
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColors.secondary,
    cardColor: Colors.grey[800],
  );
}