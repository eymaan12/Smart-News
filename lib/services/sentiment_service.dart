class SentimentService {
  final List<String> _positiveWords = [
    'excellent', 'good', 'great', 'remarkable', 'success', 'happy', 'positive',
    'fantastic', 'beautiful', 'wonderful', 'breakthrough', 'innovative', 'win'
  ];

  final List<String> _negativeWords = [
    'terrible', 'bad', 'awful', 'failure', 'sad', 'negative', 'poor',
    'horrible', 'crisis', 'disaster', 'loss', 'fail', 'worst'
  ];

  String analyzeSentiment(String text) {
    if (text.isEmpty) return 'Neutral';

    int positiveScore = 0;
    int negativeScore = 0;
    
    // Normalize text
    String normalizedText = text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    List<String> words = normalizedText.split(RegExp(r'\s+'));

    for (String word in words) {
      if (_positiveWords.contains(word)) {
        positiveScore++;
      } else if (_negativeWords.contains(word)) {
        negativeScore++;
      }
    }

    if (positiveScore > negativeScore) {
      return 'Positive';
    } else if (negativeScore > positiveScore) {
      return 'Negative';
    } else {
      return 'Neutral';
    }
  }
}
