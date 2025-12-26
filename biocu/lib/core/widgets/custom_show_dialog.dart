import 'package:flutter/material.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';
class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? cancelText;
  final VoidCallback? onCancel;
  final String confirmText;
  final VoidCallback onConfirm;
  final Color confirmColor; // 👈 Nuevo parámetro opcional

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
    this.confirmColor = AppColors.Lightsecondary, // color por defecto
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: AppTextStyles.bodyText.copyWith(
          color: AppColors.textDark,
        ),
      ),
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: onCancel ?? () => Navigator.pop(context),
            child: Text(
              cancelText!,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor, // 👈 Usamos el color personalizado
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            confirmText,
            style: AppTextStyles.buttonText.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
