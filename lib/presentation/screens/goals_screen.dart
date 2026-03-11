import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../domain/usecases/get_goal_progress.dart';
import '../blocs/goal/goal_bloc.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/goals/add'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<GoalBloc, GoalState>(
        builder: (context, state) {
          if (state is GoalLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GoalEmpty) {
            return const Center(child: Text('No goals yet. Set one!'));
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
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${goal.type.name} goal — ${goal.targetDurationMinutes} min',
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
                              LinearProgressIndicator(
                                value: pct / 100,
                              ),
                              const SizedBox(height: 4),
                              Text('${pct.toStringAsFixed(0)}%'),
                            ],
                          );
                        },
                      ),
                    ],
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
