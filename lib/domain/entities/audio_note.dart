class AudioNote {
  final String id;
  final String sessionId;
  final String filePath;
  final int durationSeconds;
  final DateTime createdAt;

  const AudioNote({
    required this.id,
    required this.sessionId,
    required this.filePath,
    required this.durationSeconds,
    required this.createdAt,
  });
}
