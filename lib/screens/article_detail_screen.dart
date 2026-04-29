import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article.dart';
import '../providers/news_provider.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(
              imageUrl: article.imageUrl,
              height: 250,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Source: ${article.source}',
                    style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  
                  // Wrap with Consumer to rebuild when sentiment/summary are updated
                  Consumer<NewsProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.analytics),
                            label: const Text('Analyze Article'),
                            onPressed: () {
                              provider.analyzeArticle(article);
                            },
                          ),
                          const SizedBox(height: 16),
                          if (article.sentiment != null) ...[
                            Card(
                              color: _getSentimentColor(article.sentiment!),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Sentiment: ${article.sentiment}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (article.summary != null) ...[
                            Card(
                              color: Colors.blue.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('AI Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(article.summary!),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'Positive':
        return Colors.green;
      case 'Negative':
        return Colors.red;
      case 'Neutral':
      default:
        return Colors.grey;
    }
  }
}
