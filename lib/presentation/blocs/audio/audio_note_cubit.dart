import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/audio_note.dart';
import '../../../domain/repositories/audio_note_repository.dart';

// States
abstract class AudioNoteState {}

class AudioNoteIdle extends AudioNoteState {
  final AudioNote? existing;
  AudioNoteIdle([this.existing]);
}

class AudioNoteRecording extends AudioNoteState {
  final int elapsedSeconds;
  AudioNoteRecording(this.elapsedSeconds);
}

class AudioNotePlaying extends AudioNoteState {
  final AudioNote note;
  final Duration position;
  final Duration total;
  AudioNotePlaying(this.note, this.position, this.total);
}

class AudioNotePaused extends AudioNoteState {
  final AudioNote note;
  final Duration position;
  final Duration total;
  AudioNotePaused(this.note, this.position, this.total);
}

// Cubit
class AudioNoteCubit extends Cubit<AudioNoteState> {
  final AudioNoteRepository _repo;
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();
  Timer? _timer;
  int _elapsed = 0;
  String? _recordingPath;
  String? _sessionId;

  AudioNoteCubit(this._repo) : super(AudioNoteIdle()) {
    _player.positionStream.listen((pos) {
      if (state is AudioNotePlaying) {
        final s = state as AudioNotePlaying;
        emit(AudioNotePlaying(s.note, pos, s.total));
      }
    });
    _player.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.completed && state is AudioNotePlaying) {
        final s = state as AudioNotePlaying;
        emit(AudioNoteIdle(s.note));
      }
    });
  }

  Future<void> loadForSession(String sessionId) async {
    _sessionId = sessionId;
    final note = await _repo.getBySessionId(sessionId);
    emit(AudioNoteIdle(note));
  }

  Future<void> startRecording() async {
    if (!await _recorder.hasPermission()) return;
    final dir = await getApplicationDocumentsDirectory();
    _recordingPath = '${dir.path}/audio_${const Uuid().v4()}.m4a';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 64000),
      path: _recordingPath!,
    );
    _elapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed++;
      if (_elapsed >= 120) {
        stopRecording();
        return;
      }
      emit(AudioNoteRecording(_elapsed));
    });
    emit(AudioNoteRecording(0));
  }

  Future<void> stopRecording() async {
    _timer?.cancel();
    await _recorder.stop();
    if (_recordingPath != null && _sessionId != null) {
      final note = AudioNote(
        id: const Uuid().v4(),
        sessionId: _sessionId!,
        filePath: _recordingPath!,
        durationSeconds: _elapsed,
        createdAt: DateTime.now(),
      );
      await _repo.save(note);
      emit(AudioNoteIdle(note));
    }
  }

  Future<void> play(AudioNote note) async {
    final file = File(note.filePath);
    if (!await file.exists()) return;
    final duration = await _player.setFilePath(note.filePath);
    _player.play();
    emit(AudioNotePlaying(note, Duration.zero, duration ?? Duration.zero));
  }

  void pause() {
    _player.pause();
    if (state is AudioNotePlaying) {
      final s = state as AudioNotePlaying;
      emit(AudioNotePaused(s.note, s.position, s.total));
    }
  }

  void resume() {
    _player.play();
    if (state is AudioNotePaused) {
      final s = state as AudioNotePaused;
      emit(AudioNotePlaying(s.note, s.position, s.total));
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> deleteNote() async {
    if (_sessionId != null) {
      await _repo.deleteBySessionId(_sessionId!);
      emit(AudioNoteIdle());
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _recorder.dispose();
    _player.dispose();
    return super.close();
  }
}
