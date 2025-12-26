import 'package:biocu/core/styles/styles_colors.dart';
import 'package:flutter/material.dart';

class AppDecorations {
  // Para las Cards de información ambiental
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );

  // Para los botones principales
  static ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(AppColors.primary),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
  );
}