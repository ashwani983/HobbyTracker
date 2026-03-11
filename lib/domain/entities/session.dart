class Session {
  final String id;
  final String hobbyId;
  final DateTime date;
  final int durationMinutes;
  final String? notes;
  final int? rating;
  final DateTime createdAt;

  const Session({
    required this.id,
    required this.hobbyId,
    required this.date,
    required this.durationMinutes,
    this.notes,
    this.rating,
    required this.createdAt,
  });
}
