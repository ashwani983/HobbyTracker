import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/entities/session.dart';
import '../../domain/entities/timer_config.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../../domain/repositories/session_repository.dart';
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
  List<Challenge> _challenges = [];
  String? _selectedHobbyId;
  String? _selectedChallengeId;
  TimerMode _selectedMode = TimerMode.stopwatch;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final hobbies = await sl<GetActiveHobbies>()();
    final challenges = await sl<ChallengeRepository>().getActiveChallenges();
    final now = DateTime.now();
    final active = challenges.where((c) =>
        c.isActive && now.isAfter(c.startDate) && now.isBefore(c.endDate)).toList();
    if (mounted) {
      setState(() {
        _hobbies = hobbies;
        _challenges = active;
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

    final notesController = TextEditingController();
    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.saveSessionQuestion),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.saveMinutesSession(minutes)),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: l.notes,
                hintText: l.notesHint,
              ),
              maxLines: 2,
            ),
          ],
        ),
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
      final notes = notesController.text.trim();
      final session = Session(
        id: const Uuid().v4(),
        hobbyId: _selectedHobbyId!,
        date: DateTime.now(),
        durationMinutes: minutes,
        notes: notes.isEmpty ? null : notes,
        createdAt: DateTime.now(),
      );
      try {
        await sl<LogSession>()(session);
        // Update challenge progress
        if (_selectedChallengeId != null) {
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid != null) {
            final allSessions = await sl<SessionRepository>().getRecentSessions(9999);
            final allHobbies = await sl<HobbyRepository>().getActiveHobbies();
            final ch = _challenges.firstWhere((c) => c.id == _selectedChallengeId);
            final catIds = allHobbies
                .where((h) => h.category.toLowerCase() == ch.category.toLowerCase())
                .map((h) => h.id)
                .toSet();
            final totalMins = allSessions
                .where((s) =>
                    catIds.contains(s.hobbyId) &&
                    !s.date.isBefore(ch.startDate) &&
                    !s.date.isAfter(ch.endDate))
                .fold<int>(0, (sum, s) => sum + s.durationMinutes) + minutes;
            await sl<ChallengeRepository>().updateProgress(ch.id, uid, totalMins);
          }
        }
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
      body: BlocConsumer<TimerCubit, TimerState>(
        listener: (context, state) {
          if (state is PomodoroBreakPrompt) {
            _showBreakPrompt(context, state);
          } else if (state is TimerStopped) {
            _onStop(context, state.elapsed);
          }
        },
        builder: (context, state) {
          final cubit = context.read<TimerCubit>();
          final isIdle = state is TimerInitial;
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
                    initialValue: _selectedHobbyId != null ? 'hobby:$_selectedHobbyId' : null,
                    decoration: const InputDecoration(labelText: 'Activity'),
                    items: [
                      const DropdownMenuItem(
                        enabled: false,
                        value: '_h_header',
                        child: Text('── Hobbies ──', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      ),
                      ..._hobbies.map((h) => DropdownMenuItem(
                          value: 'hobby:${h.id}',
                          child: Text(h.name))),
                      if (_challenges.isNotEmpty) ...[
                        const DropdownMenuItem(
                          enabled: false,
                          value: '_c_header',
                          child: Text('── Challenges ──', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        ),
                        ..._challenges.map((c) => DropdownMenuItem(
                            value: 'challenge:${c.id}',
                            child: Text('${AppConstants.emojiForCategory(c.category)} ${c.name}'))),
                      ],
                    ],
                    onChanged: isRunningOrPaused
                        ? null
                        : (v) {
                            if (v == null || v.startsWith('_')) return;
                            setState(() {
                              if (v.startsWith('hobby:')) {
                                _selectedHobbyId = v.substring(6);
                                _selectedChallengeId = null;
                              } else if (v.startsWith('challenge:')) {
                                _selectedChallengeId = v.substring(10);
                                // Pick first hobby in that category
                                final ch = _challenges.firstWhere((c) => c.id == _selectedChallengeId);
                                final match = _hobbies.where((h) =>
                                    h.category.toLowerCase() == ch.category.toLowerCase());
                                _selectedHobbyId = match.isNotEmpty ? match.first.id : _hobbies.first.id;
                              }
                            });
                          },
                  ),
                const SizedBox(height: 16),
                // Mode selector — only when idle
                if (isIdle)
                  SegmentedButton<TimerMode>(
                    segments: const [
                      ButtonSegment(value: TimerMode.stopwatch, label: Text('Stopwatch')),
                      ButtonSegment(value: TimerMode.countdown, label: Text('Countdown')),
                      ButtonSegment(value: TimerMode.pomodoro, label: Text('Pomodoro')),
                    ],
                    selected: {_selectedMode},
                    onSelectionChanged: (s) {
                      setState(() => _selectedMode = s.first);
                      cubit.setMode(s.first);
                    },
                  ),
                // Countdown duration picker
                if (isIdle && _selectedMode == TimerMode.countdown)
                  _CountdownPicker(cubit: cubit),
                const Spacer(),
                // Display
                _buildDisplay(context, state),
                const Spacer(),
                // Controls
                _buildControls(context, state, cubit),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDisplay(BuildContext context, TimerState state) {
    final theme = Theme.of(context).textTheme;
    final remaining = (state is TimerRunning) ? state.remaining : null;
    final pauseRemaining = (state is TimerPaused) ? state.remaining : null;
    final showRemaining = remaining ?? pauseRemaining;
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1.0);
    final displayStyle = scaleFactor > 1.5
        ? theme.headlineLarge
        : theme.displayLarge;

    return Column(
      children: [
        // Main time
        Semantics(
          label: showRemaining != null
              ? 'Remaining time: ${_formatDuration(showRemaining)}'
              : 'Elapsed time: ${_formatDuration(state.elapsed)}',
          liveRegion: true,
          child: Text(
            showRemaining != null
                ? _formatDuration(showRemaining)
                : _formatDuration(state.elapsed),
            style: displayStyle,
          ),
        ),
        // Pomodoro info
        if (state is TimerRunning &&
            state.mode == TimerMode.pomodoro) ...[
          const SizedBox(height: 8),
          Text(
            state.isBreak == true
                ? '☕ Break'
                : '🎯 Focus ${state.pomodoroInterval}',
            style: theme.titleMedium,
          ),
        ],
        if (state is TimerPaused &&
            state.mode == TimerMode.pomodoro) ...[
          const SizedBox(height: 8),
          Text(
            state.isBreak == true
                ? '☕ Break (paused)'
                : '🎯 Focus ${state.pomodoroInterval} (paused)',
            style: theme.titleMedium,
          ),
        ],
        // Status label
        if (state is TimerRunning && state.mode != TimerMode.pomodoro)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              AppLocalizations.of(context)!.running,
              style: theme.bodyLarge?.copyWith(color: Colors.green),
            ),
          ),
        if (state is TimerPaused && state.mode != TimerMode.pomodoro)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              AppLocalizations.of(context)!.paused,
              style: theme.bodyLarge?.copyWith(color: Colors.orange),
            ),
          ),
      ],
    );
  }

  Widget _buildControls(
      BuildContext context, TimerState state, TimerCubit cubit) {
    final l = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state is TimerInitial)
          FilledButton.icon(
            onPressed: _selectedHobbyId == null ? null : cubit.start,
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
    );
  }

  void _showBreakPrompt(BuildContext context, PomodoroBreakPrompt state) {
    final cubit = context.read<TimerCubit>();
    final breakType = state.isLongBreak ? 'Long break' : 'Short break';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('🍅 Focus complete!'),
        content: Text(
            'Interval ${state.completedIntervals} done.\n$breakType recommended.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.skipBreak();
            },
            child: const Text('Skip break'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.startBreak();
            },
            child: Text('Start $breakType'),
          ),
        ],
      ),
    );
  }
}

class _CountdownPicker extends StatefulWidget {
  final TimerCubit cubit;
  const _CountdownPicker({required this.cubit});

  @override
  State<_CountdownPicker> createState() => _CountdownPickerState();
}

class _CountdownPickerState extends State<_CountdownPicker> {
  @override
  Widget build(BuildContext context) {
    final mins = widget.cubit.countdownTarget.inMinutes;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: mins > 1
                ? () {
                    widget.cubit.setCountdownDuration(Duration(minutes: mins - 1));
                    setState(() {});
                  }
                : null,
            icon: const Icon(Icons.remove),
          ),
          Text('$mins min', style: Theme.of(context).textTheme.titleLarge),
          IconButton(
            onPressed: () {
              widget.cubit.setCountdownDuration(Duration(minutes: mins + 1));
              setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
