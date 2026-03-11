import '../entities/hobby.dart';
import '../entities/session.dart';
import '../entities/suggestion.dart';

class SuggestionEngine {
  List<Suggestion> generate({
    required List<Hobby> hobbies,
    required List<Session> recentSessions,
    required int streakDays,
  }) {
    final suggestions = <Suggestion>[];
    if (hobbies.isEmpty) {
      suggestions.add(const Suggestion(
        emoji: '🎯',
        title: 'Add your first hobby',
        subtitle: 'Start tracking something you love!',
      ));
      return suggestions;
    }

    // Suggest neglected hobbies
    final recentHobbyIds = recentSessions.map((s) => s.hobbyId).toSet();
    for (final h in hobbies) {
      if (!recentHobbyIds.contains(h.id)) {
        suggestions.add(Suggestion(
          emoji: '💡',
          title: 'Try ${h.name} today',
          subtitle: "You haven't logged a session recently.",
        ));
        if (suggestions.length >= 3) break;
      }
    }

    // Streak motivation
    if (streakDays > 0 && streakDays < 7) {
      suggestions.add(Suggestion(
        emoji: '🔥',
        title: 'Keep your $streakDays-day streak!',
        subtitle: 'Log a session today to continue.',
      ));
    } else if (streakDays >= 7) {
      suggestions.add(Suggestion(
        emoji: '⚡',
        title: 'Amazing $streakDays-day streak!',
        subtitle: 'You\'re on fire — keep going!',
      ));
    } else if (streakDays == 0 && recentSessions.isNotEmpty) {
      suggestions.add(const Suggestion(
        emoji: '🚀',
        title: 'Start a new streak',
        subtitle: 'Log a session to begin!',
      ));
    }

    // Variety suggestion
    if (recentHobbyIds.length == 1 && hobbies.length > 1) {
      suggestions.add(const Suggestion(
        emoji: '🎨',
        title: 'Mix it up',
        subtitle: 'Try a different hobby this week.',
      ));
    }

    return suggestions.take(3).toList();
  }
}
