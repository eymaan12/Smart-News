import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/news_provider.dart';
import 'article_detail_screen.dart';
import 'analytics_dashboard_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<NewsProvider>().fetchNews();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnalyticsDashboardScreen()),
              );
            },
          )
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              if (provider.isOffline)
                Container(
                  color: Colors.redAccent,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Offline Mode. Showing cached data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(
                child: provider.articles.isEmpty && provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.articles.isEmpty
                        ? const Center(child: Text('No articles available.'))
                        : RefreshIndicator(
                            onRefresh: () => provider.fetchNews(refresh: true),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: provider.articles.length + (provider.hasMoreData ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == provider.articles.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                final article = provider.articles[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ArticleDetailScreen(article: article),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: 'article_image_${article.imageUrl}',
                                          child: CachedNetworkImage(
                                            imageUrl: article.imageUrl,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.grey.shade100,
                                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.grey.shade100,
                                              child: const Icon(Icons.broken_image, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  article.title,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.3,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    article.source.toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: Theme.of(context).colorScheme.secondary,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
