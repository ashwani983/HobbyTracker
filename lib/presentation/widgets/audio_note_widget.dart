import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/audio/audio_note_cubit.dart';

class AudioNoteWidget extends StatelessWidget {
  const AudioNoteWidget({super.key});

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioNoteCubit, AudioNoteState>(
      builder: (context, state) {
        final cubit = context.read<AudioNoteCubit>();

        if (state is AudioNoteRecording) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.mic, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('Recording ${_fmt(Duration(seconds: state.elapsedSeconds))}'),
                  const Text(' / 02:00', style: TextStyle(color: Colors.grey)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.red),
                    onPressed: cubit.stopRecording,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is AudioNotePlaying || state is AudioNotePaused) {
          final pos = state is AudioNotePlaying
              ? (state).position : (state as AudioNotePaused).position;
          final total = state is AudioNotePlaying
              ? (state).total : (state as AudioNotePaused).total;
          final playing = state is AudioNotePlaying;

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                        onPressed: playing ? cubit.pause : cubit.resume,
                      ),
                      Expanded(
                        child: Slider(
                          value: pos.inMilliseconds.toDouble(),
                          max: total.inMilliseconds.toDouble().clamp(1, double.infinity),
                          onChanged: (v) => cubit.seek(Duration(milliseconds: v.toInt())),
                        ),
                      ),
                      Text(_fmt(pos)),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        // Idle state
        final existing = state is AudioNoteIdle ? state.existing : null;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.mic_none),
                const SizedBox(width: 8),
                Text(existing != null
                    ? 'Audio note (${existing.durationSeconds}s)'
                    : 'Voice memo'),
                const Spacer(),
                if (existing != null) ...[
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () => cubit.play(existing),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: cubit.deleteNote,
                  ),
                ] else
                  IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: cubit.startRecording,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
