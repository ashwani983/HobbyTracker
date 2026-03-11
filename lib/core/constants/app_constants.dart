class AppConstants {
  AppConstants._();

  static const List<String> categories = [
    'Sports',
    'Music',
    'Art',
    'Reading',
    'Gaming',
    'Cooking',
    'Fitness',
    'Photography',
    'Writing',
    'Other',
  ];

  static const Map<String, String> categoryEmojis = {
    'Sports': '⚽',
    'Music': '🎵',
    'Art': '🎨',
    'Reading': '📚',
    'Gaming': '🎮',
    'Cooking': '🍳',
    'Fitness': '💪',
    'Photography': '📷',
    'Writing': '✍️',
    'Other': '🌟',
  };

  static String emojiForCategory(String category) =>
      categoryEmojis[category] ?? '🌟';

  static const int maxRating = 5;
  static const int minRating = 1;
  static const int recentSessionsLimit = 5;
}
