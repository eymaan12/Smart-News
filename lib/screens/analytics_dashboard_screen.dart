import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/db_service.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsDashboardScreenState createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  final DbService _dbService = DbService();
  Map<String, int> _analytics = {
    'total': 0,
    'positive': 0,
    'negative': 0,
    'neutral': 0,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final data = await _dbService.getAnalytics();
    setState(() {
      _analytics = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Total Articles Processed',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_analytics['total']}',
                            style: const TextStyle(fontSize: 36, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_analytics['positive']! > 0 || _analytics['negative']! > 0 || _analytics['neutral']! > 0)
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text('Sentiment Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              Expanded(
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 40,
                                    sections: _getSections(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildLegend(Colors.green, 'Positive: ${_analytics['positive']}'),
                                  _buildLegend(Colors.red, 'Negative: ${_analytics['negative']}'),
                                  _buildLegend(Colors.grey, 'Neutral: ${_analytics['neutral']}'),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    const Expanded(
                      child: Center(
                        child: Text('No analyzed articles to display chart. Analyze some articles first!'),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  List<PieChartSectionData> _getSections() {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: _analytics['positive']!.toDouble(),
        title: '${_analytics['positive']}',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: _analytics['negative']!.toDouble(),
        title: '${_analytics['negative']}',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.grey,
        value: _analytics['neutral']!.toDouble(),
        title: '${_analytics['neutral']}',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
