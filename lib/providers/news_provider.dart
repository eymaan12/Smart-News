import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';
import '../services/sentiment_service.dart';
import '../services/summary_service.dart';

class NewsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DbService _dbService = DbService();
  final SentimentService _sentimentService = SentimentService();
  final SummaryService _summaryService = SummaryService();

  List<Article> _articles = [];
  bool _isLoading = false;
  bool _isOffline = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  bool get hasMoreData => _hasMoreData;

  NewsProvider() {
    _initConnectivity();
  }

  void _initConnectivity() {
    Connectivity().checkConnectivity().then((results) {
      _updateConnectionStatus(results);
      fetchNews(refresh: true);
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool wasOffline = _isOffline;
    _isOffline = results.isEmpty || results.contains(ConnectivityResult.none);
    
    // Automatically refresh if internet is restored
    if (wasOffline && !_isOffline) {
      fetchNews(refresh: true);
    }
    notifyListeners();
  }

  Future<void> fetchNews({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _currentPage = 1;
      _hasMoreData = true;
      if (!_isOffline) {
         _articles.clear(); // Only clear memory if we are going to fetch fresh online data
      }
    }

    if (!_hasMoreData && !refresh) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (_isOffline) {
        // Load from DB
        List<Article> cachedArticles = await _dbService.getArticles(limit: 10, offset: (_currentPage - 1) * 10);
        if (cachedArticles.isEmpty) {
          _hasMoreData = false;
        } else {
          if (refresh) {
              _articles = cachedArticles;
          } else {
              _articles.addAll(cachedArticles);
          }
          _currentPage++;
        }
      } else {
        // Fetch from API
        List<Article> newArticles = await _apiService.fetchNews(_currentPage);
        if (newArticles.isEmpty) {
          _hasMoreData = false;
        } else {
           if (refresh) {
              _articles = newArticles;
              // Clear cache and insert new on refresh
              await _dbService.clearArticles();
              await _dbService.insertArticles(newArticles);
          } else {
              _articles.addAll(newArticles);
              // Append to cache
              await _dbService.insertArticles(newArticles);
          }
          _currentPage++;
        }
      }
    } catch (e) {
      print('Error fetching news: $e');
      // If API fails unexpectedly, try loading from cache as fallback to prevent crash
      if (!_isOffline && refresh) {
          _isOffline = true; // Act as if offline
          List<Article> cachedArticles = await _dbService.getArticles(limit: 10, offset: 0);
          _articles = cachedArticles;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> analyzeArticle(Article article) async {
    // Perform sentiment analysis
    String sentiment = _sentimentService.analyzeSentiment(article.content);
    
    // Perform summarization
    String summary = await _summaryService.summarize(article.content);

    // Update the object
    article.sentiment = sentiment;
    article.summary = summary;

    // Save back to DB
    await _dbService.updateArticle(article);
    
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
