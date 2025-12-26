import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ArticleModel.dart';

class NewsService {
  final String apiKey;
  final String baseUrl = 'https://newsapi.org/v2';
  final client = http.Client(); // Exponemos el cliente para usarlo directamente

  NewsService({required this.apiKey});

  Future<List<NewsArticle>> fetchTopHeadlines() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return articles.map((json) => NewsArticle.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}