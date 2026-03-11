import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/injection.dart';
import '../../core/services/notification_service.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/usecases/cancel_reminder.dart';
import '../../domain/usecases/get_sessions_by_hobby.dart';
import '../../domain/usecases/schedule_reminder.dart';
import '../../domain/usecases/update_reminder.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/hobby_detail/hobby_detail_bloc.dart';
import '../blocs/reminder/reminder_bloc.dart';

class HobbyDetailScreen extends StatelessWidget {
  final String hobbyId;
  const HobbyDetailScreen({super.key, required this.hobbyId});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
      child: Builder(
        builder: (innerCtx) => Scaffold(
        appBar: AppBar(
          title: Text(l.hobbyDetail),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await innerCtx.push('/hobbies/$hobbyId/edit');
                if (innerCtx.mounted) {
                  innerCtx.read<HobbyDetailBloc>().add(LoadHobbyDetail(hobbyId));
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await innerCtx.push('/hobbies/$hobbyId/log');
            if (innerCtx.mounted) {
              innerCtx.read<HobbyDetailBloc>().add(LoadHobbyDetail(hobbyId));
            }
          },
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
                if (s.sessions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 4),
                      Text(l.dayStreakCount(_streak(s.sessions)),
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ],
                const Divider(height: 32),
                _RemindersSection(hobbyId: hobbyId, hobbyName: s.hobby.name),
                const Divider(height: 32),
                Text(l.sessions,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (s.sessions.isEmpty)
                  Text(l.noSessionsYet)
                else
                  ...s.sessions.map(
                    (session) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(l.durationMinutes(session.durationMinutes)),
                          subtitle: Text(
                            '${session.date.month}/${session.date.day}/${session.date.year}',
                          ),
                          trailing: session.rating != null
                              ? Text(l.ratingStars(session.rating!))
                              : null,
                        ),
                        if (session.photoPaths.isNotEmpty)
                          SizedBox(
                            height: 60,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              scrollDirection: Axis.horizontal,
                              itemCount: session.photoPaths.length,
                              separatorBuilder: (_, i2) => const SizedBox(width: 6),
                              itemBuilder: (_, i) => GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => _FullScreenImage(
                                      paths: session.photoPaths,
                                      initial: i,
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    File(session.photoPaths[i]),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, e, s) => const SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Icon(Icons.broken_image, size: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      ),
    );
  }

  static int _streak(List<Session> sessions) {
    final now = DateTime.now();
    final dates = sessions
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    if (dates.isEmpty) return 0;
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (dates.first != today && dates.first != yesterday) return 0;
    int streak = 1;
    for (var i = 1; i < dates.length; i++) {
      if (dates[i - 1].difference(dates[i]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}

class _RemindersSection extends StatelessWidget {
  final String hobbyId;
  final String hobbyName;
  const _RemindersSection({required this.hobbyId, required this.hobbyName});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l.reminders, style: Theme.of(context).textTheme.titleMedium),
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(l.noRemindersSet),
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
    final l = AppLocalizations.of(context)!;
    final granted = await NotificationService.requestPermission();
    if (!granted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.notificationPermissionDenied)),
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
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l.selectDays),
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
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _selected.isEmpty
              ? null
              : () => Navigator.pop(widget.dialogCtx, _selected.toList()),
          child: Text(l.ok),
        ),
      ],
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  final List<String> paths;
  final int initial;
  const _FullScreenImage({required this.paths, required this.initial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initial),
        itemCount: paths.length,
        itemBuilder: (_, i) => InteractiveViewer(
          child: Center(
            child: Image.file(
              File(paths[i]),
              fit: BoxFit.contain,
              errorBuilder: (_, e, s) =>
                  const Icon(Icons.broken_image, color: Colors.white, size: 48),
            ),
          ),
        ),
      ),
    );
  }
}
