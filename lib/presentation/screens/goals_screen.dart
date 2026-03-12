import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../../domain/usecases/get_goal_progress.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/goal/goal_bloc.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  Map<String, Hobby> _hobbyMap = {};

  @override
  void initState() {
    super.initState();
    _loadHobbies();
  }

  Future<void> _loadHobbies() async {
    final hobbies = await sl<GetActiveHobbies>()();
    if (mounted) {
      setState(() {
        _hobbyMap = {for (final h in hobbies) h.id: h};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/more')),
        title: Text(l.goals),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/goals/add');
          if (context.mounted) {
            context.read<GoalBloc>().add(LoadGoals());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<GoalBloc, GoalState>(
        builder: (context, state) {
          if (state is GoalLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GoalEmpty) {
            return Center(child: Text(l.noGoalsYet));
          }
          if (state is GoalError) {
            return Center(child: Text(state.message));
          }
          final goals = (state as GoalLoaded).goals;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, i) {
              final goal = goals[i];
              final hobby = _hobbyMap[goal.hobbyId];
              final hobbyName = hobby?.name ?? 'Unknown';
              return Card(
                child: InkWell(
                  onTap: () async {
                    await context.push('/goals/edit', extra: goal);
                    if (context.mounted) {
                      context.read<GoalBloc>().add(LoadGoals());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$hobbyName — ${l.goalDescription(goal.type.name, goal.targetDurationMinutes)}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () => context
                                  .read<GoalBloc>()
                                  .add(DeactivateGoalEvent(goal.id)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<double>(
                          future: sl<GetGoalProgress>()(
                            hobbyId: goal.hobbyId,
                            targetDurationMinutes: goal.targetDurationMinutes,
                            start: goal.startDate,
                            end: goal.endDate,
                          ),
                          builder: (context, snap) {
                            final pct = snap.data ?? 0;
                            return Column(
                              children: [
                                LinearProgressIndicator(value: pct / 100),
                                const SizedBox(height: 4),
                                Text(l.percentComplete(pct.toStringAsFixed(0))),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
