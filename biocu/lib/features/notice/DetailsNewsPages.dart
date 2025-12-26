import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';
import 'ArticleModel.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Noticia', style: AppTextStyles.buttonText),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardImage(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    labelPadding: EdgeInsets.symmetric(horizontal: 4),
                    label: Text(
                      'Medio Ambiente',
                      style: AppTextStyles.bodyText.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: AppColors.Lightsecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    article.title,
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14,
                          color: AppColors.textDark.withOpacity(0.6)),
                      SizedBox(width: 4),
                      Text(
                        article.publishedAt,
                        style: AppTextStyles.bodyText.copyWith(
                          fontSize: 12,
                          color: AppColors.textDark.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    article.content,
                    style: AppTextStyles.bodyText.copyWith(
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (article.url.isNotEmpty)
                    InkWell(
                      onTap: () async {
                        // final Uri url = Uri.parse(article.url);
                        // if (await canLaunchUrl(url)) {
                        //   await launchUrl(
                        //     url,
                        //     mode: LaunchMode.externalApplication, // Abre en el navegador externo
                        //   );
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text('No se pudo abrir el enlace'),
                        //       backgroundColor: AppColors.accent,
                        //     ),
                        //   );
                        // }
                      },
                      child: Text(
                        'Ver noticia original',
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
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

  Widget _buildCardImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.background,
      ),
      child: article.urlToImage.isNotEmpty
          ? CachedNetworkImage(
        imageUrl: article.urlToImage,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        errorWidget: (context, url, error) => _buildPlaceholder(),
        fit: BoxFit.cover,
      )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.eco, size: 60, color: AppColors.Lightsecondary),
          Text(
            'Imagen no disponible',
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textDark.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}