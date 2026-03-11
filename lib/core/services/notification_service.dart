import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static String? _pendingHobbyId;

  static const _channel = AndroidNotificationDetails(
    'hobby_reminders',
    'Hobby Reminders',
    channelDescription: 'Reminders to practice your hobbies',
    importance: Importance.high,
    priority: Priority.high,
  );

  static String? consumePendingHobbyId() {
    final id = _pendingHobbyId;
    _pendingHobbyId = null;
    return id;
  }

  static Future<void> init() async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: _onTap,
    );
  }

  static void _onTap(NotificationResponse response) {
    _pendingHobbyId = response.payload;
  }

  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return false;
      final granted = await android.requestNotificationsPermission() ?? false;
      if (!granted) return false;
      await android.requestExactAlarmsPermission();
      return true;
    }
    return true;
  }

  static Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required int weekDay,
    String? payload,
  }) async {
    final scheduledDate = _nextInstanceOfWeekday(weekDay, hour, minute);
    debugPrint('NotificationService.scheduleWeekly: id=$id weekDay=$weekDay '
        'time=$hour:$minute scheduled=$scheduledDate');
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(android: _channel),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: payload,
    );
  }

  static Future<void> cancel(int id) => _plugin.cancel(id: id);

  static Future<void> cancelAll() => _plugin.cancelAll();

  static Future<void> showNow({
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: _channel),
    );
  }

  static tz.TZDateTime _nextInstanceOfWeekday(int weekDay, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != weekDay) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }
    return scheduled;
  }
}
