import 'goal_type.dart';

class Goal {
  final String id;
  final String hobbyId;
  final GoalType type;
  final int targetDurationMinutes;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const Goal({
    required this.id,
    required this.hobbyId,
    required this.type,
    required this.targetDurationMinutes,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });
}
