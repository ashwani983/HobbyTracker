import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/injection.dart';
import '../../core/services/notification_service.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/usecases/cancel_reminder.dart';
import '../../domain/usecases/get_sessions_by_hobby.dart';
import '../../domain/usecases/schedule_reminder.dart';
import '../../domain/usecases/update_reminder.dart';
import '../blocs/hobby_detail/hobby_detail_bloc.dart';
import '../blocs/reminder/reminder_bloc.dart';

class HobbyDetailScreen extends StatelessWidget {
  final String hobbyId;
  const HobbyDetailScreen({super.key, required this.hobbyId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HobbyDetailBloc(
            hobbyRepository: sl<HobbyRepository>(),
            getSessionsByHobby: sl<GetSessionsByHobby>(),
          )..add(LoadHobbyDetail(hobbyId)),
        ),
        BlocProvider(
          create: (_) => ReminderBloc(
            reminderRepository: sl<ReminderRepository>(),
            scheduleReminder: sl<ScheduleReminder>(),
            cancelReminder: sl<CancelReminder>(),
            updateReminder: sl<UpdateReminder>(),
          )..add(LoadReminders(hobbyId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hobby Detail'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.go('/hobbies/$hobbyId/edit'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.go('/hobbies/$hobbyId/log'),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<HobbyDetailBloc, HobbyDetailState>(
          builder: (context, state) {
            if (state is HobbyDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HobbyDetailError) {
              return Center(child: Text(state.message));
            }
            final s = state as HobbyDetailLoaded;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(s.hobby.name,
                    style: Theme.of(context).textTheme.headlineSmall),
                if (s.hobby.description != null) ...[
                  const SizedBox(height: 8),
                  Text(s.hobby.description!),
                ],
                const SizedBox(height: 8),
                Chip(label: Text(s.hobby.category)),
                const Divider(height: 32),
                _RemindersSection(hobbyId: hobbyId, hobbyName: s.hobby.name),
                const Divider(height: 32),
                Text('Sessions',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (s.sessions.isEmpty)
                  const Text('No sessions yet.')
                else
                  ...s.sessions.map(
                    (session) => ListTile(
                      title: Text('${session.durationMinutes} min'),
                      subtitle: Text(
                        '${session.date.month}/${session.date.day}/${session.date.year}',
                      ),
                      trailing: session.rating != null
                          ? Text('⭐ ${session.rating}')
                          : null,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RemindersSection extends StatelessWidget {
  final String hobbyId;
  final String hobbyName;
  const _RemindersSection({required this.hobbyId, required this.hobbyName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Reminders', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_alarm),
              onPressed: () => _showAddReminder(context),
            ),
          ],
        ),
        BlocBuilder<ReminderBloc, ReminderState>(
          builder: (context, state) {
            if (state is ReminderLoading) {
              return const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              );
            }
            if (state is ReminderError) return Text(state.message);
            final reminders = (state as ReminderLoaded).reminders;
            if (reminders.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No reminders set. Tap + to add one.'),
              );
            }
            return Column(
              children: reminders
                  .map((r) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.alarm, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showEditReminder(context, r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.timeString,
                                        style: Theme.of(context).textTheme.bodyLarge),
                                    Text(r.weekDaysSummary,
                                        style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: () => context
                                  .read<ReminderBloc>()
                                  .add(DeleteReminderEvent(r, hobbyId)),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showAddReminder(BuildContext context) async {
    final granted = await NotificationService.requestPermission();
    if (!granted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification permission denied')),
      );
      return;
    }
    if (!context.mounted) return;

    final result = await _pickTimeAndDays(context);
    if (result == null || !context.mounted) return;

    final reminder = Reminder(
      id: const Uuid().v4(),
      hobbyId: hobbyId,
      hour: result.$1.hour,
      minute: result.$1.minute,
      weekDays: result.$2..sort(),
    );
    context.read<ReminderBloc>().add(CreateReminderEvent(reminder, hobbyName));
  }

  Future<void> _showEditReminder(BuildContext context, Reminder existing) async {
    final result = await _pickTimeAndDays(
      context,
      initialTime: TimeOfDay(hour: existing.hour, minute: existing.minute),
      initialDays: existing.weekDays,
    );
    if (result == null || !context.mounted) return;

    final updated = existing.copyWith(
      hour: result.$1.hour,
      minute: result.$1.minute,
      weekDays: result.$2..sort(),
    );
    context.read<ReminderBloc>().add(UpdateReminderEvent(updated, hobbyName));
  }

  Future<(TimeOfDay, List<int>)?> _pickTimeAndDays(
    BuildContext context, {
    TimeOfDay? initialTime,
    List<int>? initialDays,
  }) async {
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (time == null || !context.mounted) return null;

    final days = await showDialog<List<int>>(
      context: context,
      builder: (dialogCtx) =>
          _WeekDayPicker(dialogCtx, initialDays: initialDays),
    );
    if (days == null || days.isEmpty) return null;
    return (time, days);
  }
}

class _WeekDayPicker extends StatefulWidget {
  final BuildContext dialogCtx;
  final List<int>? initialDays;
  const _WeekDayPicker(this.dialogCtx, {this.initialDays});

  @override
  State<_WeekDayPicker> createState() => _WeekDayPickerState();
}

class _WeekDayPickerState extends State<_WeekDayPicker> {
  late final Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...?widget.initialDays};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Days'),
      content: Wrap(
        spacing: 8,
        children: List.generate(7, (i) {
          final day = i + 1;
          return FilterChip(
            label: Text(Reminder.dayNames[i]),
            selected: _selected.contains(day),
            onSelected: (v) => setState(() {
              v ? _selected.add(day) : _selected.remove(day);
            }),
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(widget.dialogCtx),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selected.isEmpty
              ? null
              : () => Navigator.pop(widget.dialogCtx, _selected.toList()),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
