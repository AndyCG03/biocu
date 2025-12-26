import 'package:biocu/features/enviroment_info/models/pp_assets.dart';
import 'package:flutter/services.dart';

class EnvironmentalCard {
  final String id;
  final String category;
  final String title;
  final String description;
  final String? imagePath; // Nullable
  final String content;

  EnvironmentalCard({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.imagePath, // Puede ser null
    required this.content,
  });

  // Getter para obtener la ruta de imagen segura
  String get safeImagePath {
    // 1. Primero intenta usar la imagen específica si existe
    if (imagePath != null && imagePath!.isNotEmpty) {
      return imagePath!;
    }

    // 2. Busca una imagen por defecto según la categoría
    final defaultImage = AppAssets.defaultCategoryImages[category];

    // 3. Si no encuentra para la categoría, usa la imagen por defecto genérica
    return defaultImage ?? AppAssets.defaultCategoryImages['default']!;
  }

  // Método para verificar si la imagen existe (opcional)
  Future<bool> get hasImage async {
    try {
      if (safeImagePath.isNotEmpty) {
        await rootBundle.load(safeImagePath);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}