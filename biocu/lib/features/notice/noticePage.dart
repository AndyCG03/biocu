import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';
import 'ArticleModel.dart';
import 'ArticleService.dart';
import 'DetailsNewsPages.dart';


class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late Future<List<NewsArticle>> futureNews;
  final NewsService newsService = NewsService(apiKey: '45210b6c57974639827a0be5593d80c3');
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    futureNews = _fetchEnvironmentalNews();
  }

  Future<List<NewsArticle>> _fetchEnvironmentalNews() async {
    try {
      // Cambiamos a búsqueda directa por temas ambientales
      final response = await newsService.client.get(
        Uri.parse('https://newsapi.org/v2/everything?q=environment OR ecology OR "climate change" OR sustainability OR pollution&language=es&sortBy=publishedAt&apiKey=${newsService.apiKey}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];

        if (articles.isEmpty) {
          // Si no hay resultados, intentamos con términos más generales
          return _fetchGeneralNewsWithFallback();
        }

        return articles.map((json) => NewsArticle.fromJson(json)).toList();
      } else {
        // Si hay error en la API, intentamos con noticias generales
        return _fetchGeneralNewsWithFallback();
      }
    } catch (e) {
      // En caso de cualquier error, intentamos con noticias generales
      return _fetchGeneralNewsWithFallback();
    }
  }

  Future<List<NewsArticle>> _fetchGeneralNewsWithFallback() async {
    final allNews = await newsService.fetchTopHeadlines();

    // Filtro mejorado con más palabras clave y en español
    final environmentalKeywords = [
      'ambiente', 'ambiental', 'medio ambiente', 'cambio climático',
      'sostenibilidad', 'ecología', 'contaminación', 'naturaleza',
      'biodiversidad', 'renovable', 'conservación', 'calentamiento global',
      'energía limpia', 'fauna', 'flora', 'ecosistema', 'reciclaje',
      'emisiones', 'carbono', 'verde', 'sustentable'
    ];

    final filteredNews = allNews.where((article) {
      final title = article.title.toLowerCase();
      final description = article.description.toLowerCase();

      return environmentalKeywords.any((keyword) =>
      title.contains(keyword) || description.contains(keyword));
    }).toList();

    // Si aún no hay resultados, mostramos las primeras noticias con marca de "Revisar"
    if (filteredNews.isEmpty && allNews.isNotEmpty) {
      return allNews.take(5).map((article) => article.copyWith(
          title: '[Revisar] ${article.title}',
          description: 'Esta noticia podría estar relacionada con temas ambientales. ${article.description}'
      )).toList();
    }

    return filteredNews;
  }

  List<NewsArticle> _filterNews(List<NewsArticle> articles) {
    if (_searchQuery.isEmpty) return articles;
    return articles.where((article) {
      return article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar noticias...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        )
            : Text('Noticias Ambientales', style: AppTextStyles.buttonText),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar noticias',
                  style: AppTextStyles.bodyText.copyWith(color: AppColors.textDark)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No hay noticias ambientales disponibles',
                  style: AppTextStyles.bodyText.copyWith(color: AppColors.textDark)),
            );
          } else {
            final filteredNews = _filterNews(snapshot.data!);
            if (filteredNews.isEmpty) {
              return Center(
                child: Text('No se encontraron resultados',
                    style: AppTextStyles.bodyText.copyWith(color: AppColors.textDark)),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: filteredNews.length,
              itemBuilder: (context, index) {
                final article = filteredNews[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  color: AppColors.card,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailScreen(article: article),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardImage(article),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Chip(
                                labelPadding: EdgeInsets.symmetric(horizontal: 4),
                                label: Text(
                                  'Medio Ambiente',
                                  style: AppTextStyles.bodyText.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                backgroundColor: AppColors.Lightsecondary,
                              ),
                              SizedBox(height: 8),
                              Text(
                                article.title,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 16,
                                  color: AppColors.textDark,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                article.description,
                                style: AppTextStyles.bodyText.copyWith(
                                  fontSize: 14,
                                  color: AppColors.textDark,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCardImage(NewsArticle article) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
          Icon(Icons.eco, size: 50, color: AppColors.Lightsecondary),
          Text(
            'Imagen ilustrativa',
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textDark.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}