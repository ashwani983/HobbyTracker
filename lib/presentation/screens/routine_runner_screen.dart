import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../domain/repositories/routine_repository.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../blocs/routine/routine_bloc.dart';

class RoutineRunnerScreen extends StatefulWidget {
  final String routineId;
  const RoutineRunnerScreen({super.key, required this.routineId});
  @override
  State<RoutineRunnerScreen> createState() => _RoutineRunnerScreenState();
}

class _RoutineRunnerScreenState extends State<RoutineRunnerScreen> {
  Map<String, String> _hobbyNames = {};
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _loadHobbies();
    _startRoutine();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _startRoutine() async {
    final repo = sl<RoutineRepository>();
    final routine = await repo.getRoutineById(widget.routineId);
    if (routine != null && mounted) {
      context.read<RoutineBloc>().add(StartRoutineEvent(routine));
    }
  }

  Future<void> _loadHobbies() async {
    final hobbies = await sl<GetActiveHobbies>()();
    if (mounted) {
      setState(() {
        _hobbyNames = {for (final h in hobbies) h.id: h.name};
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Running Routine')),
      body: BlocConsumer<RoutineBloc, RoutineState>(
        listener: (context, state) {
          if (state is RoutineCompleted) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('🎉 Routine Complete!'),
                content: Text('All ${state.routine.steps.length} hobbies done.'),
                actions: [
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.go('/routines');
                      context.read<RoutineBloc>().add(LoadRoutines());
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is RoutineRunning) {
            final step = state.routine.steps[state.currentStep];
            final hobbyName = _hobbyNames[step.hobbyId] ?? step.hobbyId;
            final target = Duration(minutes: step.targetMinutes);
            final elapsed = context.read<RoutineBloc>().liveElapsed;
            final progress = elapsed.inSeconds / target.inSeconds;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Progress indicator
                  LinearProgressIndicator(
                    value: (state.currentStep + progress.clamp(0, 1)) / state.routine.steps.length,
                  ),
                  const SizedBox(height: 8),
                  Text('Step ${state.currentStep + 1} of ${state.routine.steps.length}'),
                  const Spacer(),
                  // Current hobby
                  Text(hobbyName, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Text(_fmt(elapsed), style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 8),
                  Text('Target: ${step.targetMinutes} min',
                      style: Theme.of(context).textTheme.bodyLarge),
                  if (state.isPaused)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('Paused', style: TextStyle(color: Colors.orange)),
                    ),
                  const Spacer(),
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!state.isPaused) ...[
                        FilledButton.icon(
                          onPressed: () => context.read<RoutineBloc>().add(PauseRoutineEvent()),
                          icon: const Icon(Icons.pause),
                          label: const Text('Pause'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => context.read<RoutineBloc>().add(AdvanceStepEvent()),
                          icon: const Icon(Icons.skip_next),
                          label: Text(state.currentStep + 1 >= state.routine.steps.length ? 'Finish' : 'Next'),
                        ),
                      ] else ...[
                        FilledButton.icon(
                          onPressed: () => context.read<RoutineBloc>().add(ResumeRoutineEvent()),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Resume'),
                        ),
                      ],
                      const SizedBox(width: 12),
                      TextButton.icon(
                        onPressed: () {
                          context.read<RoutineBloc>().add(AbortRoutineEvent());
                          context.go('/routines');
                        },
                        icon: const Icon(Icons.stop),
                        label: const Text('Abort'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
