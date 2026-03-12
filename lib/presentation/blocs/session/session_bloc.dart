import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/repositories/challenge_repository.dart';
import '../../../domain/repositories/hobby_repository.dart';
import '../../../domain/repositories/session_repository.dart';
import '../../../domain/usecases/log_session.dart';

// Events
abstract class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

class LogSessionEvent extends SessionEvent {
  final Session session;
  const LogSessionEvent(this.session);
  @override
  List<Object?> get props => [session.id];
}

// States
abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionSaving extends SessionState {}

class SessionSaved extends SessionState {}

class SessionError extends SessionState {
  final String message;
  const SessionError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final LogSession _logSession;
  final HobbyRepository _hobbyRepo;
  final SessionRepository _sessionRepo;
  final ChallengeRepository _challengeRepo;

  SessionBloc({
    required LogSession logSession,
    required HobbyRepository hobbyRepo,
    required SessionRepository sessionRepo,
    required ChallengeRepository challengeRepo,
  })  : _logSession = logSession,
        _hobbyRepo = hobbyRepo,
        _sessionRepo = sessionRepo,
        _challengeRepo = challengeRepo,
        super(SessionInitial()) {
    on<LogSessionEvent>(_onLog);
  }

  Future<void> _onLog(
    LogSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionSaving());
    try {
      await _logSession(event.session);
      await _updateChallengeProgress(event.session);
      emit(SessionSaved());
    } on ValidationFailure catch (e) {
      emit(SessionError(e.message));
    } on DatabaseFailure catch (e) {
      emit(SessionError(e.message));
    }
  }

  Future<void> _updateChallengeProgress(Session session) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final hobby = await _hobbyRepo.getHobbyById(session.hobbyId);
      if (hobby == null) return;
      final challenges = await _challengeRepo.getActiveChallenges();
      final matching = challenges.where((c) =>
          c.isActive &&
          c.category.toLowerCase() == hobby.category.toLowerCase() &&
          DateTime.now().isAfter(c.startDate) &&
          DateTime.now().isBefore(c.endDate));
      if (matching.isEmpty) return;
      for (final c in matching) {
        // Sum sessions only within challenge date range for matching category
        final allSessions = await _sessionRepo.getRecentSessions(9999);
        final allHobbies = await _hobbyRepo.getActiveHobbies();
        final catIds = allHobbies
            .where((h) => h.category.toLowerCase() == c.category.toLowerCase())
            .map((h) => h.id)
            .toSet();
        final totalMins = allSessions
            .where((s) =>
                catIds.contains(s.hobbyId) &&
                !s.date.isBefore(c.startDate) &&
                !s.date.isAfter(c.endDate))
            .fold<int>(0, (sum, s) => sum + s.durationMinutes);
        await _challengeRepo.updateProgress(c.id, uid, totalMins);
      }
    } catch (_) {
      // Don't fail session logging if challenge update fails
    }
  }
}
