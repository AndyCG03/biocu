import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import '../../../core/styles/styles_texts.dart';
import '../models/enviroment_card_model.dart';

class CardDetailScreen extends StatelessWidget {
  final EnvironmentalCard card;

  const CardDetailScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          card.title,
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: AppColors.primary,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal con efecto de sombra
            // _buildHeroImage(),
            // const SizedBox(height: 20),

            // Sección de categoría
            _buildCategoryChip(),
            const SizedBox(height: 16),

            // Título con estilo destacado
            Text(
              card.title,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // Fecha de publicación (si aplica)
            _buildDateInfo(),
            const SizedBox(height: 16),

            // Contenido principal
            _buildContentSection(),
            const SizedBox(height: 24),

            // Acciones
            //_buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return FutureBuilder<bool>(
      future: _checkImageExists(card.safeImagePath),
      builder: (context, snapshot) {
        final imageExists = snapshot.data ?? false;

        return Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Imagen o placeholder
                imageExists
                    ? Image.asset(
                  card.safeImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                )
                    : _buildPlaceholder(),

                // Gradiente decorativo
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.Lightsecondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.eco,
            size: 16,
            color: AppColors.Lightsecondary,
          ),
          const SizedBox(width: 6),
          Text(
            card.category.toUpperCase(),
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.Lightsecondary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo() {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: AppColors.textDark.withOpacity(0.6),
        ),
        const SizedBox(width: 6),
        Text(
          'Publicado el ${DateTime.now().toString().substring(0, 10)}', // Ejemplo, ajusta según tus datos
          style: AppTextStyles.bodyText.copyWith(
            color: AppColors.textDark.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            card.content,
            style: AppTextStyles.bodyText.copyWith(
              fontSize: 15,
              height: 1.6,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.share, size: 20, color: Colors.white),
            label: const Text('Compartir'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              // Lógica para compartir
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.bookmark_border,
                size: 20,
                color: AppColors.primary),
            label: Text(
              'Guardar',
              style: TextStyle(color: AppColors.primary),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // Lógica para guardar
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.card,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 60, color: AppColors.Lightsecondary),
            const SizedBox(height: 8),
            Text(
              'Imagen ilustrativa',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textDark.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkImageExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }
}