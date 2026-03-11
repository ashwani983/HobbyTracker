import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/widget_service.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/usecases/get_active_hobbies.dart';
import '../../../domain/usecases/get_recent_sessions.dart';
import '../../../domain/usecases/get_streak_count.dart';
import '../../../domain/repositories/badge_repository.dart';
import '../../../domain/repositories/session_repository.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {}

// Per-hobby stat for dashboard cards
class HobbyStats {
  final String hobbyId;
  final String name;
  final String category;
  final int weeklyMinutes;

  const HobbyStats({
    required this.hobbyId,
    required this.name,
    required this.category,
    required this.weeklyMinutes,
  });
}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int activeHobbyCount;
  final int weeklyTotalMinutes;
  final int streakDays;
  final String? recentBadgeName;
  final List<Session> recentSessions;
  final List<HobbyStats> hobbyStats;
  const DashboardLoaded({
    required this.activeHobbyCount,
    required this.weeklyTotalMinutes,
    required this.recentSessions,
    this.streakDays = 0,
    this.recentBadgeName,
    this.hobbyStats = const [],
  });
  @override
  List<Object?> get props =>
      [activeHobbyCount, weeklyTotalMinutes, streakDays, recentBadgeName, recentSessions.length, hobbyStats.length];
}

class DashboardEmpty extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetActiveHobbies _getActiveHobbies;
  final GetRecentSessions _getRecentSessions;
  final SessionRepository _sessionRepository;
  final GetStreakCount _getStreakCount;
  final BadgeRepository _badgeRepository;

  DashboardBloc({
    required GetActiveHobbies getActiveHobbies,
    required GetRecentSessions getRecentSessions,
    required SessionRepository sessionRepository,
    required GetStreakCount getStreakCount,
    required BadgeRepository badgeRepository,
  })  : _getActiveHobbies = getActiveHobbies,
        _getRecentSessions = getRecentSessions,
        _sessionRepository = sessionRepository,
        _getStreakCount = getStreakCount,
        _badgeRepository = badgeRepository,
        super(DashboardLoading()) {
    on<LoadDashboard>(_onLoad);
  }

  Future<void> _onLoad(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final hobbies = await _getActiveHobbies();
      final recent = await _getRecentSessions(
        AppConstants.recentSessionsLimit,
      );

      if (hobbies.isEmpty && recent.isEmpty) {
        emit(DashboardEmpty());
        return;
      }

      final now = DateTime.now();
      final weekday = now.weekday;
      final startOfWeek = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: weekday - 1));
      final endOfWeek = startOfWeek
          .add(const Duration(days: 7))
          .subtract(const Duration(microseconds: 1));

      final weekSessions = await _sessionRepository.getSessionsInRange(
        startOfWeek,
        endOfWeek,
      );
      final weeklyTotal = weekSessions.fold<int>(
        0,
        (sum, s) => sum + s.durationMinutes,
      );

      // Per-hobby weekly minutes
      final minutesByHobby = <String, int>{};
      for (final s in weekSessions) {
        minutesByHobby[s.hobbyId] =
            (minutesByHobby[s.hobbyId] ?? 0) + s.durationMinutes;
      }
      final hobbyStatsL = hobbies
          .map((h) => HobbyStats(
                hobbyId: h.id,
                name: h.name,
                category: h.category,
                weeklyMinutes: minutesByHobby[h.id] ?? 0,
              ))
          .toList()
        ..sort((a, b) => b.weeklyMinutes.compareTo(a.weeklyMinutes));

      final streak = await _getStreakCount();

      emit(DashboardLoaded(
        activeHobbyCount: hobbies.length,
        weeklyTotalMinutes: weeklyTotal,
        recentSessions: recent,
        streakDays: streak,
        recentBadgeName: (await _badgeRepository.getUnlockedBadges()).isNotEmpty
            ? (await _badgeRepository.getUnlockedBadges()).last.type.name
            : null,
        hobbyStats: hobbyStatsL,
      ));

      // Update home screen widgets
      final today = DateTime.now();
      final todaySessions = weekSessions.where((s) =>
          s.date.year == today.year &&
          s.date.month == today.month &&
          s.date.day == today.day).toList();
      final todayMin = todaySessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
      final hobbyNames = {for (final h in hobbies) h.id: h.name};
      final sorted = minutesByHobby.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final top = sorted.take(3).map((e) => (hobbyNames[e.key] ?? 'Unknown', e.value)).toList();
      try {
        await WidgetService.updateWidgetData(
          todayMinutes: todayMin,
          streakDays: streak,
          topHobbies: top,
        );
        if (hobbyStatsL.isNotEmpty) {
          await WidgetService.updateHobbyWidget(
            hobbyName: hobbyStatsL.first.name,
            weeklyMinutes: hobbyStatsL.first.weeklyMinutes,
          );
        }
      } catch (_) {}
    } on DatabaseFailure catch (e) {
      emit(DashboardError(e.message));
    }
  }
}
