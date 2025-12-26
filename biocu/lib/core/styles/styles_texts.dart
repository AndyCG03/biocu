import 'package:biocu/core/styles/styles_colors.dart';
import 'package:flutter/material.dart';

import '../constants/assets_constants.dart';

class AppTextStyles {
  // Títulos
  static TextStyle headlineLarge = TextStyle(
    fontFamily: AssetConstants.primaryFontFamily,
    fontSize: 24,
    color: AppColors.textDark,
  );

  // Subtítulos
  static TextStyle titleMedium = TextStyle(
    fontFamily: AssetConstants.primaryFontFamily,
    fontSize: 18,
    color: AppColors.textDark,
  );

  // Cuerpo de texto
  static TextStyle bodyText = TextStyle(
    fontFamily: AssetConstants.decorativeFontFamily,
    fontSize: 14,
    color: AppColors.textLight,
  );

  // Botones
  static TextStyle buttonText = TextStyle(
    fontFamily: AssetConstants.primaryFontFamily,
    fontSize: 16,
    color: Colors.white,
  );
}