import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../../domain/usecases/log_session.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/timer/timer_cubit.dart';

class TimerScreen extends StatefulWidget {
  final String? initialHobbyId;
  const TimerScreen({super.key, this.initialHobbyId});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  List<Hobby> _hobbies = [];
  String? _selectedHobbyId;

  @override
  void initState() {
    super.initState();
    _loadHobbies();
  }

  Future<void> _loadHobbies() async {
    final hobbies = await sl<GetActiveHobbies>()();
    if (mounted) {
      setState(() {
        _hobbies = hobbies;
        if (hobbies.isNotEmpty && _selectedHobbyId == null) {
          _selectedHobbyId = widget.initialHobbyId ?? hobbies.first.id;
        }
      });
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> _onStop(BuildContext context, Duration elapsed) async {
    final l = AppLocalizations.of(context)!;
    final minutes = elapsed.inMinutes;
    if (minutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.sessionTooShort)),
      );
      return;
    }
    if (_selectedHobbyId == null) return;

    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.saveSessionQuestion),
        content: Text(l.saveMinutesSession(minutes)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.discard),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.save),
          ),
        ],
      ),
    );

    if (save == true && context.mounted) {
      final session = Session(
        id: const Uuid().v4(),
        hobbyId: _selectedHobbyId!,
        date: DateTime.now(),
        durationMinutes: minutes,
        createdAt: DateTime.now(),
      );
      try {
        await sl<LogSession>()(session);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.sessionSaved)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.timer)),
      body: BlocBuilder<TimerCubit, TimerState>(
        builder: (context, state) {
          final cubit = context.read<TimerCubit>();
          final isRunningOrPaused =
              state is TimerRunning || state is TimerPaused;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_hobbies.isEmpty)
                  Text(l.addHobbyFirstTimer)
                else
                  DropdownButtonFormField<String>(
                    initialValue: _selectedHobbyId,
                    decoration: InputDecoration(labelText: l.selectHobby),
                    items: _hobbies
                        .map((h) => DropdownMenuItem(
                            value: h.id, child: Text(h.name)))
                        .toList(),
                    onChanged: isRunningOrPaused
                        ? null
                        : (v) => setState(() => _selectedHobbyId = v),
                  ),
                const Spacer(),
                Text(
                  _formatDuration(state.elapsed),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                if (isRunningOrPaused)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state is TimerRunning ? l.running : l.paused,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: state is TimerRunning
                                ? Colors.green
                                : Colors.orange,
                          ),
                    ),
                  ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state is TimerInitial)
                      FilledButton.icon(
                        onPressed:
                            _selectedHobbyId == null ? null : cubit.start,
                        icon: const Icon(Icons.play_arrow),
                        label: Text(l.start),
                      ),
                    if (state is TimerRunning) ...[
                      FilledButton.icon(
                        onPressed: cubit.pause,
                        icon: const Icon(Icons.pause),
                        label: Text(l.pause),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          cubit.stop();
                          _onStop(context, state.elapsed);
                        },
                        icon: const Icon(Icons.stop),
                        label: Text(l.stop),
                      ),
                    ],
                    if (state is TimerPaused) ...[
                      FilledButton.icon(
                        onPressed: cubit.resume,
                        icon: const Icon(Icons.play_arrow),
                        label: Text(l.resume),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          cubit.stop();
                          _onStop(context, state.elapsed);
                        },
                        icon: const Icon(Icons.stop),
                        label: Text(l.stop),
                      ),
                      const SizedBox(width: 12),
                      TextButton.icon(
                        onPressed: cubit.discard,
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l.discard),
                      ),
                    ],
                    if (state is TimerStopped)
                      FilledButton.icon(
                        onPressed: cubit.discard,
                        icon: const Icon(Icons.refresh),
                        label: Text(l.reset),
                      ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
