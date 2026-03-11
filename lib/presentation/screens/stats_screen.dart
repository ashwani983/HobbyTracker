import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/stats/stats_bloc.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          if (state is StatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StatsEmpty) {
            return const Center(child: Text('No data for this period.'));
          }
          if (state is StatsError) {
            return Center(child: Text(state.message));
          }
          final s = state as StatsLoaded;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _PeriodSelector(current: s.period),
              const SizedBox(height: 24),
              Text('Time per Hobby',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: s.data.perHobbyDurations.entries
                        .toList()
                        .asMap()
                        .entries
                        .map((e) => BarChartGroupData(
                              x: e.key,
                              barRods: [
                                BarChartRodData(
                                  toY: e.value.value.toDouble(),
                                  width: 16,
                                ),
                              ],
                            ))
                        .toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (val, meta) {
                            final entries =
                                s.data.perHobbyDurations.keys.toList();
                            final idx = val.toInt();
                            if (idx < 0 || idx >= entries.length) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: SizedBox(
                                width: 60,
                                child: Text(
                                  entries[idx],
                                  style: const TextStyle(fontSize: 9),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Distribution',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: s.data.perHobbyProportions.entries
                        .toList()
                        .asMap()
                        .entries
                        .map((e) => PieChartSectionData(
                              value: e.value.value * 100,
                              title:
                                  '${(e.value.value * 100).toStringAsFixed(0)}%',
                              color: Colors.primaries[
                                  e.key % Colors.primaries.length],
                              radius: 60,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Daily Activity',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: _dailySpots(s.data.dailyTotals),
                        isCurved: true,
                        barWidth: 2,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<FlSpot> _dailySpots(Map<DateTime, int> daily) {
    if (daily.isEmpty) return [];
    final sorted = daily.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final first = sorted.first.key;
    return sorted
        .map((e) => FlSpot(
              e.key.difference(first).inDays.toDouble(),
              e.value.toDouble(),
            ))
        .toList();
  }
}

class _PeriodSelector extends StatelessWidget {
  final TimePeriod current;
  const _PeriodSelector({required this.current});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TimePeriod>(
      segments: TimePeriod.values
          .map((p) => ButtonSegment(value: p, label: Text(p.name)))
          .toList(),
      selected: {current},
      onSelectionChanged: (s) =>
          context.read<StatsBloc>().add(ChangeTimePeriod(s.first)),
    );
  }
}
