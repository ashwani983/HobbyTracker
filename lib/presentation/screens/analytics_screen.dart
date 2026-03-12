import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../blocs/analytics/analytics_bloc.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, Hobby> _hobbies = {};

  @override
  void initState() {
    super.initState();
    _loadHobbies();
    context.read<AnalyticsBloc>().add(LoadAnalytics());
  }

  Future<void> _loadHobbies() async {
    final list = await sl<GetActiveHobbies>()();
    if (mounted) setState(() => _hobbies = {for (final h in list) h.id: h});
  }

  String _hobbyName(String id) => _hobbies[id]?.name ?? id;

  static const _dowNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/more')),
        title: const Text('Analytics'),
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) return const Center(child: CircularProgressIndicator());
          if (state is! AnalyticsLoaded) return const Center(child: Text('Tap to load'));
          final r = state.result;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Most productive
              _card('Most Productive', [
                if (r.mostProductiveDow != null) 'Day: ${_dowNames[r.mostProductiveDow!]}',
                if (r.mostProductiveHour != null) 'Time: ${r.mostProductiveHour!}:00',
              ]),

              // Consistency scores
              if (r.consistencyScores.isNotEmpty)
                _card('Consistency (30 days)', r.consistencyScores.entries
                    .map((e) => '${_hobbyName(e.key)}: ${e.value}%')
                    .toList()),

              // Rolling averages
              if (r.avg7.isNotEmpty)
                _card('7-Day Avg (min/day)', r.avg7.entries
                    .map((e) => '${_hobbyName(e.key)}: ${e.value.toStringAsFixed(1)}')
                    .toList()),
              if (r.avg30.isNotEmpty)
                _card('30-Day Avg (min/day)', r.avg30.entries
                    .map((e) => '${_hobbyName(e.key)}: ${e.value.toStringAsFixed(1)}')
                    .toList()),

              // Correlation matrix
              if (r.correlationMatrix.isNotEmpty)
                _card('Hobby Correlations', r.correlationMatrix.entries.expand((e) =>
                    e.value.entries.map((c) =>
                        '${_hobbyName(e.key)} + ${_hobbyName(c.key)}: ${c.value} days'))
                    .toSet().toList()),

              // Monthly summary
              if (r.monthlySummary != null) ...[
                _card('Monthly Summary', [
                  'Sessions: ${r.monthlySummary!.sessionsCount}',
                  'Total: ${r.monthlySummary!.totalMinutes} min',
                  if (r.monthlySummary!.mostActiveHobbyId != null)
                    'Most active: ${_hobbyName(r.monthlySummary!.mostActiveHobbyId!)}',
                  'Goals completed: ${r.monthlySummary!.goalsCompleted}',
                  'Badges earned: ${r.monthlySummary!.badgesEarned}',
                ]),
              ],

              // Pin metrics
              const SizedBox(height: 16),
              const Text('Pin to Dashboard (up to 3)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _pinToggle('Consistency Scores', 'pin_consistency'),
              _pinToggle('Most Productive', 'pin_productive'),
              _pinToggle('Monthly Summary', 'pin_monthly'),
            ],
          );
        },
      ),
    );
  }

  Widget _card(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...items.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(t),
            )),
          ],
        ),
      ),
    );
  }

  Widget _pinToggle(String label, String key) {
    final prefs = sl<SharedPreferences>();
    return StatefulBuilder(
      builder: (ctx, setSt) {
        final pinned = prefs.getBool(key) ?? false;
        return SwitchListTile(
          dense: true,
          title: Text(label),
          value: pinned,
          onChanged: (v) async {
            final pins = ['pin_consistency', 'pin_productive', 'pin_monthly']
                .where((k) => prefs.getBool(k) ?? false).length;
            if (v && pins >= 3) return;
            await prefs.setBool(key, v);
            setSt(() {});
          },
        );
      },
    );
  }
}
