import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final String hobbyId;
  final int hour;
  final int minute;
  final List<int> weekDays; // 1=Mon, 7=Sun
  final bool isActive;

  const Reminder({
    required this.id,
    required this.hobbyId,
    required this.hour,
    required this.minute,
    required this.weekDays,
    this.isActive = true,
  });

  String get timeString =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  static const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String get weekDaysSummary =>
      weekDays.length == 7 ? 'Every day' : weekDays.map((d) => dayNames[d - 1]).join(', ');

  Reminder copyWith({
    int? hour,
    int? minute,
    List<int>? weekDays,
    bool? isActive,
  }) =>
      Reminder(
        id: id,
        hobbyId: hobbyId,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        weekDays: weekDays ?? this.weekDays,
        isActive: isActive ?? this.isActive,
      );

  @override
  List<Object?> get props => [id, hobbyId, hour, minute, weekDays, isActive];
}
