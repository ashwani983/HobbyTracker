import '../entities/audio_note.dart';

abstract class AudioNoteRepository {
  Future<AudioNote?> getBySessionId(String sessionId);
  Future<void> save(AudioNote note);
  Future<void> deleteBySessionId(String sessionId);
}
