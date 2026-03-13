import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/entities/suggestion.dart';
import '../../domain/usecases/analytics_service.dart';
import '../../domain/usecases/suggestion_engine.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/hobby_list/hobby_list_bloc.dart';
import '../blocs/suggestion/suggestion_cubit.dart';
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
      body: FocusTraversalGroup(
        child: BlocProvider(
        create: (_) => SuggestionCubit(SuggestionEngine()),
        child: Column(
        children: [
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
                  const _PinnedMetrics(),
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
      ),
    );
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
    return Semantics(
      label: '$hobbyCount active hobbies, $weeklyMinutes minutes this week, $streakDays day streak',
      child: Card(
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
      ),
    );
  }
}

class _PinnedMetrics extends StatefulWidget {
  const _PinnedMetrics();
  @override
  State<_PinnedMetrics> createState() => _PinnedMetricsState();
}

class _PinnedMetricsState extends State<_PinnedMetrics> {
  AnalyticsResult? _result;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await sl<AnalyticsService>().compute();
      if (mounted) setState(() => _result = r);
    } catch (_) {}
  }

  static const _dowNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    if (_result == null) return const SizedBox();
    SharedPreferences? prefs;
    try { prefs = sl<SharedPreferences>(); } catch (_) { return const SizedBox(); }
    final pins = <Widget>[];

    if (prefs.getBool('pin_productive') ?? false) {
      final r = _result!;
      if (r.mostProductiveDow != null) {
        pins.add(_chip('📅 ${_dowNames[r.mostProductiveDow!]} ${r.mostProductiveHour ?? 0}:00'));
      }
    }
    if (prefs.getBool('pin_consistency') ?? false) {
      final top = _result!.consistencyScores.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      if (top.isNotEmpty) pins.add(_chip('📊 Top: ${top.first.value}%'));
    }
    if (prefs.getBool('pin_monthly') ?? false) {
      final m = _result!.monthlySummary;
      if (m != null) pins.add(_chip('📈 ${m.totalMinutes} min this month'));
    }

    if (pins.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(spacing: 8, children: pins),
    );
  }

  Widget _chip(String text) => Chip(label: Text(text, style: const TextStyle(fontSize: 12)));
}
