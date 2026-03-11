import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/hobby.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/hobby_list/hobby_list_bloc.dart';
import '../blocs/theme/theme_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboard());
  }

  Map<String, Hobby> _hobbyMap(HobbyListState state) {
    if (state is HobbyListLoaded) {
      return {for (final h in state.hobbies) h.id: h};
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return IconButton(
                icon: Icon(mode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode),
                tooltip: 'Toggle theme',
                onPressed: () {
                  final cubit = context.read<ThemeCubit>();
                  cubit.setTheme(
                    mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.description_outlined),
            tooltip: 'Terms & Conditions',
            onPressed: () => context.go('/terms'),
          ),
        ],
      ),
      body: BlocBuilder<HobbyListBloc, HobbyListState>(
        builder: (context, hobbyState) {
          final hobbyMap = _hobbyMap(hobbyState);
          return BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DashboardEmpty) {
                return const Center(
                  child: Text('No data yet. Add a hobby to get started!'),
                );
              }
              if (state is DashboardError) {
                return Center(child: Text(state.message));
              }
              final s = state as DashboardLoaded;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SummaryCard(
                    hobbyCount: s.activeHobbyCount,
                    weeklyMinutes: s.weeklyTotalMinutes,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recent Sessions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (s.recentSessions.isEmpty)
                    const Text('No sessions logged yet.')
                  else
                    ...s.recentSessions.map((session) {
                      final hobby = hobbyMap[session.hobbyId];
                      final hobbyName = hobby?.name ?? 'Unknown';
                      final emoji = hobby != null
                          ? AppConstants.emojiForCategory(hobby.category)
                          : '🌟';
                      return ListTile(
                        leading: Text(emoji, style: const TextStyle(fontSize: 24)),
                        title: Text(hobbyName),
                        subtitle: Text(
                          '${session.durationMinutes} min · '
                          '${session.date.month}/${session.date.day}/${session.date.year}',
                        ),
                        trailing: session.rating != null
                            ? Text('⭐ ${session.rating}')
                            : null,
                      );
                    }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int hobbyCount;
  final int weeklyMinutes;
  const _SummaryCard({required this.hobbyCount, required this.weeklyMinutes});

  @override
  Widget build(BuildContext context) {
    final hours = weeklyMinutes ~/ 60;
    final mins = weeklyMinutes % 60;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text('$hobbyCount',
                    style: Theme.of(context).textTheme.headlineMedium),
                const Text('Active Hobbies'),
              ],
            ),
            Column(
              children: [
                Text('${hours}h ${mins}m',
                    style: Theme.of(context).textTheme.headlineMedium),
                const Text('This Week'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
