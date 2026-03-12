import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/session.dart';
import '../../../domain/repositories/session_repository.dart';

// Events
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
  @override
  List<Object?> get props => [];
}

class LoadMonth extends CalendarEvent {
  final DateTime month;
  const LoadMonth(this.month);
  @override
  List<Object?> get props => [month];
}

class SelectDay extends CalendarEvent {
  final DateTime day;
  const SelectDay(this.day);
  @override
  List<Object?> get props => [day];
}

class LoadHeatmap extends CalendarEvent {}

// States
abstract class CalendarState extends Equatable {
  const CalendarState();
  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final DateTime focusedMonth;
  final Map<DateTime, List<Session>> sessionsByDay;
  final DateTime? selectedDay;
  final List<Session> selectedDaySessions;
  const CalendarLoaded({
    required this.focusedMonth,
    required this.sessionsByDay,
    this.selectedDay,
    this.selectedDaySessions = const [],
  });
  @override
  List<Object?> get props => [focusedMonth, sessionsByDay, selectedDay, selectedDaySessions];
}

class HeatmapLoaded extends CalendarState {
  final Map<DateTime, int> minutesByDay; // day -> total minutes
  const HeatmapLoaded(this.minutesByDay);
  @override
  List<Object?> get props => [minutesByDay];
}

// Bloc
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final SessionRepository _sessionRepo;

  CalendarBloc(this._sessionRepo) : super(CalendarInitial()) {
    on<LoadMonth>(_onLoadMonth);
    on<SelectDay>(_onSelectDay);
    on<LoadHeatmap>(_onLoadHeatmap);
  }

  Future<void> _onLoadMonth(LoadMonth e, Emitter<CalendarState> emit) async {
    final start = DateTime(e.month.year, e.month.month);
    final end = DateTime(e.month.year, e.month.month + 1);
    final sessions = await _sessionRepo.getSessionsInRange(start, end);
    final byDay = <DateTime, List<Session>>{};
    for (final s in sessions) {
      final key = DateTime(s.date.year, s.date.month, s.date.day);
      byDay.putIfAbsent(key, () => []).add(s);
    }
    emit(CalendarLoaded(focusedMonth: e.month, sessionsByDay: byDay));
  }

  Future<void> _onSelectDay(SelectDay e, Emitter<CalendarState> emit) async {
    if (state is! CalendarLoaded) return;
    final s = state as CalendarLoaded;
    final key = DateTime(e.day.year, e.day.month, e.day.day);
    emit(CalendarLoaded(
      focusedMonth: s.focusedMonth,
      sessionsByDay: s.sessionsByDay,
      selectedDay: key,
      selectedDaySessions: s.sessionsByDay[key] ?? [],
    ));
  }

  Future<void> _onLoadHeatmap(LoadHeatmap e, Emitter<CalendarState> emit) async {
    final now = DateTime.now();
    final start = DateTime(now.year - 1, now.month, now.day);
    final sessions = await _sessionRepo.getSessionsInRange(start, now);
    final byDay = <DateTime, int>{};
    for (final s in sessions) {
      final key = DateTime(s.date.year, s.date.month, s.date.day);
      byDay[key] = (byDay[key] ?? 0) + s.durationMinutes;
    }
    emit(HeatmapLoaded(byDay));
  }
}
