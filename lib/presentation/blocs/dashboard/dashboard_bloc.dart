import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/usecases/get_active_hobbies.dart';
import '../../../domain/usecases/get_recent_sessions.dart';
import '../../../domain/repositories/session_repository.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {}

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
  final List<Session> recentSessions;
  const DashboardLoaded({
    required this.activeHobbyCount,
    required this.weeklyTotalMinutes,
    required this.recentSessions,
  });
  @override
  List<Object?> get props =>
      [activeHobbyCount, weeklyTotalMinutes, recentSessions.length];
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

  DashboardBloc({
    required GetActiveHobbies getActiveHobbies,
    required GetRecentSessions getRecentSessions,
    required SessionRepository sessionRepository,
  })  : _getActiveHobbies = getActiveHobbies,
        _getRecentSessions = getRecentSessions,
        _sessionRepository = sessionRepository,
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
      final weekday = now.weekday; // Monday = 1
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

      emit(DashboardLoaded(
        activeHobbyCount: hobbies.length,
        weeklyTotalMinutes: weeklyTotal,
        recentSessions: recent,
      ));
    } on DatabaseFailure catch (e) {
      emit(DashboardError(e.message));
    }
  }
}
