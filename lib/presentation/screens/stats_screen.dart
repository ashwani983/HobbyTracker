import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_stats.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/stats/stats_bloc.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _touchedPieIndex = -1;
  int _touchedBarIndex = -1;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.stats)),
      body: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          if (state is StatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StatsEmpty) {
            return Center(child: Text(l.noDataForPeriod));
          }
          if (state is StatsError) {
            return Center(child: Text(state.message));
          }
          final s = state as StatsLoaded;
          final hobbyNames = s.data.perHobbyDurations.keys.toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _PeriodSelector(current: s.period),
              const SizedBox(height: 16),
              // Insight cards
              _InsightCards(data: s.data),
              const SizedBox(height: 24),
              // Bar chart
              Text(l.timePerHobby,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIdx, rod, rodIdx) {
                          final name = groupIdx < hobbyNames.length
                              ? hobbyNames[groupIdx]
                              : '';
                          return BarTooltipItem(
                            '$name\n${rod.toY.toInt()}m',
                            const TextStyle(
                                color: Colors.white, fontSize: 12),
                          );
                        },
                      ),
                      touchCallback: (event, response) {
                        setState(() {
                          _touchedBarIndex = response?.spot?.touchedBarGroupIndex ?? -1;
                        });
                      },
                    ),
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
                                  color: e.key == _touchedBarIndex
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.primaryContainer,
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
                            final idx = val.toInt();
                            if (idx < 0 || idx >= hobbyNames.length) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: SizedBox(
                                width: 60,
                                child: Text(
                                  hobbyNames[idx],
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
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 40),
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
              // Pie chart
              Text(l.distribution,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 240,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          _touchedPieIndex =
                              response?.touchedSection?.touchedSectionIndex ??
                                  -1;
                        });
                      },
                    ),
                    sections: s.data.perHobbyProportions.entries
                        .toList()
                        .asMap()
                        .entries
                        .map((e) {
                      final isTouched = e.key == _touchedPieIndex;
                      final pct =
                          (e.value.value * 100).toStringAsFixed(0);
                      return PieChartSectionData(
                        value: e.value.value * 100,
                        title: isTouched
                            ? '${e.value.key}\n$pct%'
                            : '${e.value.key}\n$pct%',
                        color: Colors
                            .primaries[e.key % Colors.primaries.length],
                        radius: isTouched ? 75 : 60,
                        titleStyle: TextStyle(
                          fontSize: isTouched ? 13 : 11,
                          color: Colors.white,
                          fontWeight:
                              isTouched ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Line chart
              Text(l.dailyActivity,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: Builder(builder: (context) {
                  final sorted = s.data.dailyTotals.entries.toList()
                    ..sort((a, b) => a.key.compareTo(b.key));
                  if (sorted.isEmpty) {
                    return Center(child: Text(l.noDataForPeriod));
                  }
                  final dayLabels = sorted
                      .map((e) =>
                          ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                              [e.key.weekday - 1])
                      .toList();
                  return BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIdx, rod, rodIdx) {
                            if (groupIdx >= sorted.length) return null;
                            final d = sorted[groupIdx].key;
                            return BarTooltipItem(
                              '${d.month}/${d.day}\n${rod.toY.toInt()}m',
                              const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            );
                          },
                        ),
                      ),
                      barGroups: sorted.asMap().entries.map((e) {
                        return BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: e.value.value.toDouble(),
                              width: sorted.length > 14 ? 6 : 14,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiary,
                            ),
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (val, meta) {
                              final idx = val.toInt();
                              if (idx < 0 || idx >= dayLabels.length) {
                                return const SizedBox.shrink();
                              }
                              // Show every label if <=7, else every other
                              if (sorted.length > 7 && idx % 2 != 0) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(dayLabels[idx],
                                    style: const TextStyle(fontSize: 10)),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true, reservedSize: 40),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

}

class _InsightCards extends StatelessWidget {
  final StatsResult data;
  const _InsightCards({required this.data});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // Best day
    String? bestDayText;
    if (data.dailyTotals.isNotEmpty) {
      final best = data.dailyTotals.entries.reduce(
          (a, b) => a.value >= b.value ? a : b);
      bestDayText = l.minutesOnDate(
          best.value, '${best.key.month}/${best.key.day}');
    }
    // Most active hobby
    String? mostActiveText;
    if (data.perHobbyDurations.isNotEmpty) {
      final best = data.perHobbyDurations.entries.reduce(
          (a, b) => a.value >= b.value ? a : b);
      mostActiveText = '${best.key} — ${l.minutesTotal(best.value)}';
    }

    if (bestDayText == null && mostActiveText == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (bestDayText != null)
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('📅', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(l.bestDay,
                        style: Theme.of(context).textTheme.labelLarge),
                    Text(bestDayText,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
        if (mostActiveText != null)
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(l.mostActiveHobby,
                        style: Theme.of(context).textTheme.labelLarge),
                    Text(mostActiveText,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final TimePeriod current;
  const _PeriodSelector({required this.current});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final labels = {
      TimePeriod.week: l.week,
      TimePeriod.month: l.month,
      TimePeriod.year: l.year,
    };
    return SegmentedButton<TimePeriod>(
      segments: TimePeriod.values
          .map((p) => ButtonSegment(value: p, label: Text(labels[p]!)))
          .toList(),
      selected: {current},
      onSelectionChanged: (s) =>
          context.read<StatsBloc>().add(ChangeTimePeriod(s.first)),
    );
  }
}
