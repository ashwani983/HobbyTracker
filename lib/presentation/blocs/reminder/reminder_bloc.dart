import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/reminder.dart';
import '../../../domain/repositories/reminder_repository.dart';
import '../../../domain/usecases/cancel_reminder.dart';
import '../../../domain/usecases/schedule_reminder.dart';
import '../../../domain/usecases/update_reminder.dart';

// Events
abstract class ReminderEvent extends Equatable {
  const ReminderEvent();
  @override
  List<Object?> get props => [];
}

class LoadReminders extends ReminderEvent {
  final String hobbyId;
  const LoadReminders(this.hobbyId);
  @override
  List<Object?> get props => [hobbyId];
}

class CreateReminderEvent extends ReminderEvent {
  final Reminder reminder;
  final String hobbyName;
  const CreateReminderEvent(this.reminder, this.hobbyName);
  @override
  List<Object?> get props => [reminder.id];
}

class UpdateReminderEvent extends ReminderEvent {
  final Reminder reminder;
  final String hobbyName;
  const UpdateReminderEvent(this.reminder, this.hobbyName);
  @override
  List<Object?> get props => [reminder];
}

class DeleteReminderEvent extends ReminderEvent {
  final Reminder reminder;
  final String hobbyId;
  const DeleteReminderEvent(this.reminder, this.hobbyId);
  @override
  List<Object?> get props => [reminder.id];
}

// States
abstract class ReminderState extends Equatable {
  const ReminderState();
  @override
  List<Object?> get props => [];
}

class ReminderLoading extends ReminderState {}

class ReminderLoaded extends ReminderState {
  final List<Reminder> reminders;
  final int _stamp; // force uniqueness so BlocBuilder always rebuilds
  ReminderLoaded(this.reminders) : _stamp = DateTime.now().microsecondsSinceEpoch;
  @override
  List<Object?> get props => [_stamp, reminders];
}

class ReminderError extends ReminderState {
  final String message;
  const ReminderError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository _repo;
  final ScheduleReminder _schedule;
  final CancelReminder _cancel;
  final UpdateReminder _update;

  ReminderBloc({
    required ReminderRepository reminderRepository,
    required ScheduleReminder scheduleReminder,
    required CancelReminder cancelReminder,
    required UpdateReminder updateReminder,
  })  : _repo = reminderRepository,
        _schedule = scheduleReminder,
        _cancel = cancelReminder,
        _update = updateReminder,
        super(ReminderLoading()) {
    on<LoadReminders>(_onLoad);
    on<CreateReminderEvent>(_onCreate);
    on<UpdateReminderEvent>(_onUpdate);
    on<DeleteReminderEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadReminders event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    try {
      final reminders = await _repo.getRemindersByHobby(event.hobbyId);
      emit(ReminderLoaded(reminders));
    } catch (e) {
      debugPrint('ReminderBloc._onLoad error: $e');
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _onCreate(CreateReminderEvent event, Emitter<ReminderState> emit) async {
    try {
      await _schedule(event.reminder, event.hobbyName);
      final reminders = await _repo.getRemindersByHobby(event.reminder.hobbyId);
      emit(ReminderLoaded(reminders));
    } catch (e) {
      debugPrint('ReminderBloc._onCreate error: $e');
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateReminderEvent event, Emitter<ReminderState> emit) async {
    try {
      await _update(event.reminder, event.hobbyName);
      final reminders = await _repo.getRemindersByHobby(event.reminder.hobbyId);
      emit(ReminderLoaded(reminders));
    } catch (e) {
      debugPrint('ReminderBloc._onUpdate error: $e');
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteReminderEvent event, Emitter<ReminderState> emit) async {
    try {
      await _cancel(event.reminder);
      final reminders = await _repo.getRemindersByHobby(event.hobbyId);
      emit(ReminderLoaded(reminders));
    } catch (e) {
      debugPrint('ReminderBloc._onDelete error: $e');
      emit(ReminderError(e.toString()));
    }
  }
}
