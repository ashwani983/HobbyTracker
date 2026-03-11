import 'dart:io';

import 'package:home_widget/home_widget.dart';

import '../../domain/entities/session.dart';

class WidgetService {
  static Future<void> init() async {
    if (Platform.isIOS) {
      HomeWidget.setAppGroupId('group.com.hobbytracker.app');
    }
  }

  static Future<void> updateWidgetData({
    required int todayMinutes,
    required int streakDays,
    required List<(String name, int minutes)> topHobbies,
  }) async {
    await HomeWidget.saveWidgetData('today_minutes', '$todayMinutes');
    await HomeWidget.saveWidgetData('streak_days', '$streakDays');

    for (var i = 0; i < 3; i++) {
      if (i < topHobbies.length) {
        final h = topHobbies[i];
        await HomeWidget.saveWidgetData('top_hobby_${i + 1}', '${h.$1} — ${h.$2}m');
      } else {
        await HomeWidget.saveWidgetData('top_hobby_${i + 1}', '—');
      }
    }

    await HomeWidget.updateWidget(
      name: 'SmallWidgetProvider',
      androidName: 'SmallWidgetProvider',
      qualifiedAndroidName: 'com.hobbytracker.app.SmallWidgetProvider',
    );
    await HomeWidget.updateWidget(
      name: 'MediumWidgetProvider',
      androidName: 'MediumWidgetProvider',
      qualifiedAndroidName: 'com.hobbytracker.app.MediumWidgetProvider',
    );
  }

  static Future<void> onSessionLogged({
    required List<Session> todaySessions,
    required int streakDays,
    required Map<String, int> weeklyMinutesByHobby,
    required Map<String, String> hobbyNames,
  }) async {
    final todayMin = todaySessions.fold<int>(0, (s, e) => s + e.durationMinutes);

    final sorted = weeklyMinutesByHobby.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(3).map((e) => (hobbyNames[e.key] ?? 'Unknown', e.value)).toList();

    await updateWidgetData(
      todayMinutes: todayMin,
      streakDays: streakDays,
      topHobbies: top,
    );
  }
}
