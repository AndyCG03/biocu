class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String content;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.content,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      content: json['content'] ?? 'Contenido no disponible',
      publishedAt: json['publishedAt'] ?? '',
    );
  }

  NewsArticle copyWith({
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? content,
    String? publishedAt,
  }) {
    return NewsArticle(
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      content: content ?? this.content,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

}