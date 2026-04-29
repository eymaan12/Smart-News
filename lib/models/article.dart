class Article {
  final String id;
  final String title;
  final String imageUrl;
  final String source;
  final String content;
  String? sentiment;
  String? summary;

  Article({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.source,
    required this.content,
    this.sentiment,
    this.summary,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? json['url'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'No Title',
      imageUrl: json['urlToImage'] ?? json['image'] ?? 'https://via.placeholder.com/150',
      source: json['source'] is Map ? json['source']['name'] : (json['source'] ?? 'Unknown Source'),
      content: json['content'] ?? json['description'] ?? 'No Content',
      sentiment: json['sentiment'],
      summary: json['summary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'source': source,
      'content': content,
      'sentiment': sentiment,
      'summary': summary,
    };
  }

  // SQLite helper methods
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'source': source,
      'content': content,
      'sentiment': sentiment,
      'summary': summary,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      source: map['source'],
      content: map['content'],
      sentiment: map['sentiment'],
      summary: map['summary'],
    );
  }
}
