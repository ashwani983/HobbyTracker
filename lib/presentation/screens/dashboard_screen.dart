import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/entities/suggestion.dart';
import '../../domain/usecases/suggestion_engine.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/hobby_list/hobby_list_bloc.dart';
import '../blocs/suggestion/suggestion_cubit.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/update/update_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.dashboard),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return IconButton(
                icon: Icon(mode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode),
                tooltip: l.toggleTheme,
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
            icon: const Icon(Icons.settings),
            tooltip: l.settings,
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => SuggestionCubit(SuggestionEngine()),
        child: Column(
        children: [
          BlocBuilder<UpdateCubit, UpdateState>(
            builder: (ctx, uState) {
              if (uState is! UpdateAvailable) return const SizedBox.shrink();
              return MaterialBanner(
                content: Text(l.updateAvailable(uState.release.tagName)),
                actions: [
                  TextButton(
                    onPressed: () => ctx.read<UpdateCubit>().dismiss(),
                    child: Text(l.later),
                  ),
                  TextButton(
                    onPressed: () => _openRelease(uState.release.htmlUrl),
                    child: Text(l.update),
                  ),
                ],
              );
            },
          ),
          Expanded(child: BlocBuilder<HobbyListBloc, HobbyListState>(
        builder: (context, hobbyState) {
          return BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is DashboardEmpty) {
                return Center(child: Text(l.noDataYet));
              }
              if (state is DashboardError) {
                return Center(child: Text(state.message));
              }
              final s = state as DashboardLoaded;
              final hobbyList = hobbyState is HobbyListLoaded
                  ? hobbyState.hobbies
                  : <Hobby>[];
              context.read<SuggestionCubit>().refresh(
                    hobbies: hobbyList,
                    recentSessions: s.recentSessions,
                    streakDays: s.streakDays,
                  );
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SummaryCard(
                    hobbyCount: s.activeHobbyCount,
                    weeklyMinutes: s.weeklyTotalMinutes,
                    streakDays: s.streakDays,
                    recentBadge: s.recentBadgeName,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SuggestionCubit, List<Suggestion>>(
                    builder: (context, suggestions) {
                      if (suggestions.isEmpty) return const SizedBox();
                      return Column(
                        children: suggestions
                            .map((s) => Card(
                                  child: ListTile(
                                    leading: Text(s.emoji,
                                        style: const TextStyle(fontSize: 24)),
                                    title: Text(s.title),
                                    subtitle: Text(s.subtitle),
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  ),
                  if (s.hobbyStats.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      l.hobbies,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...s.hobbyStats.map((hs) {
                      final emoji = AppConstants.emojiForCategory(hs.category);
                      final h = hs.weeklyMinutes ~/ 60;
                      final m = hs.weeklyMinutes % 60;
                      return Card(
                        child: ListTile(
                          leading: Text(emoji,
                              style: const TextStyle(fontSize: 24)),
                          title: Text(hs.name),
                          subtitle: Text('${l.durationHoursMinutes(h, m)} ${l.thisWeek}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              context.go('/hobbies/${hs.hobbyId}'),
                        ),
                      );
                    }),
                  ],
                ],
              );
            },
          );
        },
      )),
        ],
      ),
      ),
    );
  }

  static Future<void> _openRelease(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SummaryCard extends StatelessWidget {
  final int hobbyCount;
  final int weeklyMinutes;
  final int streakDays;
  final String? recentBadge;
  const _SummaryCard({
    required this.hobbyCount,
    required this.weeklyMinutes,
    this.streakDays = 0,
    this.recentBadge,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final hours = weeklyMinutes ~/ 60;
    final mins = weeklyMinutes % 60;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('$hobbyCount',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(l.activeHobbies),
                  ],
                ),
                Column(
                  children: [
                    Text(l.durationHoursMinutes(hours, mins),
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(l.thisWeek),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(l.streakDays(streakDays),
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(l.dayStreak),
                  ],
                ),
                if (recentBadge != null)
                  Column(
                    children: [
                      Text('🏆',
                          style: Theme.of(context).textTheme.headlineMedium),
                      Text(recentBadge!),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
