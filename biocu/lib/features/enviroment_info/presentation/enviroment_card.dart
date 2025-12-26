import 'package:flutter/material.dart';
import '../../../core/styles/styles_colors.dart';
import '../../../core/styles/styles_texts.dart';
import 'card_details.dart';
import '../models/enviroment_card_data.dart';
import '../models/enviroment_card_model.dart';

class EnvironmentalCardsScreen extends StatelessWidget {
  const EnvironmentalCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Lógica para actualizar contenido
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: environmentalCards.length,
        itemBuilder: (context, index) {
          return _buildEnvironmentalCard(context, environmentalCards[index]);
        },
      ),
    );
  }

  Widget _buildEnvironmentalCard(BuildContext context, EnvironmentalCard card) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell( // Envolvemos toda la tarjeta con InkWell
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => CardDetailScreen(card: card),
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardImage(card),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    label: Text(
                      card.category,
                      style: AppTextStyles.bodyText.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    backgroundColor: AppColors.Lightsecondary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    card.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    card.description,
                    style: AppTextStyles.bodyText.copyWith(
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Mantenemos el botón "Leer más" por consistencia visual
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: null, // Ahora es null porque la acción está en el InkWell
                    child: Text(
                      'Leer más',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(EnvironmentalCard card) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: Colors.grey[200],
      ),
      child: card.imagePath != null
          ? Image.asset(
        card.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.eco, size: 30, color: Colors.green[300]),
          Text(
            'Imagen ilustrativa',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}