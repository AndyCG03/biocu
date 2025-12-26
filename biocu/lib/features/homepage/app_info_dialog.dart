import 'package:flutter/material.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';

class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            'Acerca de Biocu',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🧬 Biocu es una aplicación pensada para fortalecer la conciencia ambiental en la comunidad universitaria y más allá.',
              style: AppTextStyles.bodyText.copyWith(color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            Text(
              '🌱 Objetivo:',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              'Facilitar el acceso a información ambiental, reportar problemáticas ecológicas, y promover el desarrollo sostenible en el entorno cubano.',
              style: AppTextStyles.bodyText.copyWith(color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            Text(
              '👥 Equipo de desarrollo:',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              '• Andy Clemente Gago\n• Gabriela Vázquez Castanedo \n• Roger A. Oliva Rodríguez',
              style: AppTextStyles.bodyText.copyWith(color: AppColors.textDark),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'Cerrar',
            style: AppTextStyles.buttonText.copyWith(color: AppColors.primary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
