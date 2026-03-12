import 'dart:io';

import '../../domain/entities/audio_note.dart';
import '../../domain/repositories/audio_note_repository.dart';
import '../datasources/database.dart';

class AudioNoteRepositoryImpl implements AudioNoteRepository {
  final AppDatabase _db;
  AudioNoteRepositoryImpl(this._db);

  @override
  Future<AudioNote?> getBySessionId(String sessionId) async {
    final row = await _db.getAudioNoteBySessionId(sessionId);
    if (row == null) return null;
    return AudioNote(
      id: row.id,
      sessionId: row.sessionId,
      filePath: row.filePath,
      durationSeconds: row.durationSeconds,
      createdAt: row.createdAt,
    );
  }

  @override
  Future<void> save(AudioNote note) => _db.insertAudioNote(
        AudioNoteTableCompanion.insert(
          id: note.id,
          sessionId: note.sessionId,
          filePath: note.filePath,
          durationSeconds: note.durationSeconds,
          createdAt: note.createdAt,
        ),
      );

  @override
  Future<void> deleteBySessionId(String sessionId) async {
    final note = await getBySessionId(sessionId);
    if (note != null) {
      final file = File(note.filePath);
      if (await file.exists()) await file.delete();
    }
    await _db.deleteAudioNoteBySessionId(sessionId);
  }
}
