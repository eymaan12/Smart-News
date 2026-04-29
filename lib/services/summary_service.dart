class SummaryService {
  // Simulates AI summarization
  Future<String> summarize(String content) async {
    // Simulate network delay for AI API
    await Future.delayed(const Duration(seconds: 1));

    // Simple mock summary logic: Take the first sentence or first 50 characters
    if (content.isEmpty) return "No content to summarize.";
    
    // Split by period to get first sentence roughly
    List<String> sentences = content.split('.');
    String summary = sentences.first.trim();
    
    // Just a placeholder AI response format
    return "AI Summary: $summary.";
  }
}
