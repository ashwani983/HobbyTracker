import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../blocs/calendar/calendar_bloc.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _showHeatmap = false;
  Map<String, Hobby> _hobbies = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _loadHobbies();
    context.read<CalendarBloc>().add(LoadMonth(DateTime.now()));
  }

  Future<void> _loadHobbies() async {
    final list = await sl<GetActiveHobbies>()();
    if (mounted) setState(() => _hobbies = {for (final h in list) h.id: h});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: Icon(_showHeatmap ? Icons.calendar_month : Icons.grid_on),
            tooltip: _showHeatmap ? 'Monthly view' : 'Heatmap',
            onPressed: () {
              setState(() => _showHeatmap = !_showHeatmap);
              if (_showHeatmap) {
                context.read<CalendarBloc>().add(LoadHeatmap());
              } else {
                context.read<CalendarBloc>().add(LoadMonth(DateTime.now()));
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (_showHeatmap && state is HeatmapLoaded) {
            return _buildHeatmap(state);
          }
          if (state is CalendarLoaded) {
            return _buildCalendar(state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCalendar(CalendarLoaded state) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime(2020),
          lastDay: DateTime(2030),
          focusedDay: state.focusedMonth,
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) => setState(() => _calendarFormat = format),
          selectedDayPredicate: (d) =>
              state.selectedDay != null && isSameDay(d, state.selectedDay!),
          onDaySelected: (sel, focused) =>
              context.read<CalendarBloc>().add(SelectDay(sel)),
          onPageChanged: (focused) =>
              context.read<CalendarBloc>().add(LoadMonth(focused)),
          eventLoader: (day) {
            final key = DateTime(day.year, day.month, day.day);
            return state.sessionsByDay[key] ?? [];
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (ctx, day, events) {
              if (events.isEmpty) return null;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events.take(3).map((e) {
                  final s = e as dynamic;
                  final hobby = _hobbies[s.hobbyId];
                  return Container(
                    width: 6, height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hobby != null
                          ? Color(hobby.color)
                          : Theme.of(ctx).colorScheme.primary,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        if (state.selectedDay != null) ...[
          const Divider(),
          Expanded(
            child: state.selectedDaySessions.isEmpty
                ? const Center(child: Text('No sessions'))
                : ListView.builder(
                    itemCount: state.selectedDaySessions.length,
                    itemBuilder: (ctx, i) {
                      final s = state.selectedDaySessions[i];
                      final hobby = _hobbies[s.hobbyId];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: hobby != null
                              ? Color(hobby.color)
                              : null,
                          radius: 16,
                          child: Text(
                            hobby?.name.substring(0, 1).toUpperCase() ?? '?',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        title: Text(hobby?.name ?? s.hobbyId),
                        subtitle: Text('${s.durationMinutes} min'),
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeatmap(HeatmapLoaded state) {
    final now = DateTime.now();
    final start = DateTime(now.year - 1, now.month, now.day);
    final maxMin = state.minutesByDay.values.fold<int>(1, (a, b) => a > b ? a : b);
    final scrollCtrl = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollCtrl.hasClients) scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
    });

    return SingleChildScrollView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Activity — Past 12 Months'),
          const SizedBox(height: 12),
          SizedBox(
            height: 7 * 14.0,
            child: Row(
              children: List.generate(53, (week) {
                return Column(
                  children: List.generate(7, (dow) {
                    final day = start.add(Duration(days: week * 7 + dow));
                    if (day.isAfter(now)) return const SizedBox(width: 12, height: 12);
                    final key = DateTime(day.year, day.month, day.day);
                    final mins = state.minutesByDay[key] ?? 0;
                    final intensity = mins > 0 ? (mins / maxMin).clamp(0.15, 1.0) : 0.0;
                    return Tooltip(
                      message: '${key.month}/${key.day}: $mins min',
                      child: Container(
                        width: 10, height: 10,
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: mins > 0
                              ? Colors.green.withValues(alpha: intensity)
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
