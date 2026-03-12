class RoutineStep {
  final String hobbyId;
  final int targetMinutes;
  const RoutineStep({required this.hobbyId, required this.targetMinutes});

  Map<String, dynamic> toJson() => {'hobbyId': hobbyId, 'targetMinutes': targetMinutes};
  factory RoutineStep.fromJson(Map<String, dynamic> j) => RoutineStep(
        hobbyId: j['hobbyId'] as String,
        targetMinutes: j['targetMinutes'] as int,
      );
}

class Routine {
  final String id;
  final String name;
  final List<RoutineStep> steps;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Routine({
    required this.id,
    required this.name,
    required this.steps,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });
}

class RoutineSchedule {
  final int? dbId;
  final String routineId;
  final int dayOfWeek; // 1=Mon, 7=Sun
  final int hour;
  final int minute;

  const RoutineSchedule({
    this.dbId,
    required this.routineId,
    required this.dayOfWeek,
    required this.hour,
    required this.minute,
  });
}
