import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  final String _apiKey = 'a74e759ed69a4078a4df5cbed2a1e6c4';
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  // Fetches paginated news from NewsAPI
  Future<List<Article>> fetchNews(int page, {int pageSize = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?country=us&page=$page&pageSize=$pageSize&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == 'ok' && data['articles'] != null) {
          final List<dynamic> articlesJson = data['articles'];
          
          return articlesJson.map((json) => Article.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load news: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load news. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Failed to connect to API');
    }
  }
}
