import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/session.dart';
import '../../domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> syncSessionToCalendar(Session session, String hobbyName) async {
    final title = Uri.encodeComponent('Hobby: $hobbyName');
    final desc = Uri.encodeComponent('Logged ${session.durationMinutes} min via Hobby Tracker');
    final endTime = session.date.add(Duration(minutes: session.durationMinutes));
    final uri = Uri.parse(
      'https://www.google.com/calendar/render?action=TEMPLATE'
      '&text=$title&details=$desc'
      '&dates=${_toGCalDate(session.date)}/${_toGCalDate(endTime)}'
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Calendar sync error: $e');
    }
  }

  String _toGCalDate(DateTime dt) {
    return '${dt.year}'
        '${dt.month.toString().padLeft(2, '0')}'
        '${dt.day.toString().padLeft(2, '0')}'
        'T${dt.hour.toString().padLeft(2, '0')}'
        '${dt.minute.toString().padLeft(2, '0')}'
        '00';
  }

  @override
  Future<void> removeSessionFromCalendar(String sessionId) async {}
}
