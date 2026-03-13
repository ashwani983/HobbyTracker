import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class WearableService {
  static const _channel = MethodChannel('com.hobbytracker.app/wearable');
  static final WearableService instance = WearableService._();

  final _timerStoppedController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onTimerStopped => _timerStoppedController.stream;

  WearableService._() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onTimerStopped':
        final data = jsonDecode(call.arguments as String) as Map<String, dynamic>;
        _timerStoppedController.add(data);
        break;
    }
  }

  /// Send hobby list to watch
  Future<void> syncHobbies(List<Map<String, dynamic>> hobbies) async {
    try {
      await _channel.invokeMethod('syncHobbies', jsonEncode(hobbies));
    } on PlatformException catch (_) {}
  }

  /// Send timer state to watch
  Future<void> syncTimerState({
    required String hobbyId,
    required String hobbyName,
    required bool isRunning,
    required int elapsedSeconds,
  }) async {
    try {
      await _channel.invokeMethod('syncTimerState', jsonEncode({
        'hobbyId': hobbyId,
        'hobbyName': hobbyName,
        'isRunning': isRunning,
        'elapsedSeconds': elapsedSeconds,
      }));
    } on PlatformException catch (_) {}
  }

  /// Send today's stats to watch
  Future<void> syncDailyStats({
    required int totalMinutesToday,
    required int currentStreak,
  }) async {
    try {
      await _channel.invokeMethod('syncDailyStats', jsonEncode({
        'totalMinutesToday': totalMinutesToday,
        'currentStreak': currentStreak,
      }));
    } on PlatformException catch (_) {}
  }

  void dispose() {
    _timerStoppedController.close();
  }
}
