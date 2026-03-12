import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/challenge.dart';
import '../../../domain/repositories/challenge_repository.dart';

// Events
abstract class ChallengeEvent {}

class LoadChallenges extends ChallengeEvent {}

class CreateChallenge extends ChallengeEvent {
  final String name;
  final String category;
  final int targetMinutes;
  final DateTime startDate;
  final DateTime endDate;
  final int participantLimit;
  CreateChallenge({
    required this.name,
    required this.category,
    required this.targetMinutes,
    required this.startDate,
    required this.endDate,
    required this.participantLimit,
  });
}

class JoinByCode extends ChallengeEvent {
  final String code;
  JoinByCode(this.code);
}

class LeaveChallenge extends ChallengeEvent {
  final String challengeId;
  LeaveChallenge(this.challengeId);
}

class DeleteChallenge extends ChallengeEvent {
  final String challengeId;
  DeleteChallenge(this.challengeId);
}

class WatchLeaderboard extends ChallengeEvent {
  final String challengeId;
  WatchLeaderboard(this.challengeId);
}

class _LeaderboardUpdated extends ChallengeEvent {
  final List<LeaderboardEntry> entries;
  _LeaderboardUpdated(this.entries);
}

// States
abstract class ChallengeState {}

class ChallengeInitial extends ChallengeState {}

class ChallengeLoading extends ChallengeState {}

class ChallengesLoaded extends ChallengeState {
  final List<Challenge> challenges;
  ChallengesLoaded(this.challenges);
}

class ChallengeError extends ChallengeState {
  final String message;
  ChallengeError(this.message);
}

class LeaderboardLoaded extends ChallengeState {
  final Challenge challenge;
  final List<LeaderboardEntry> entries;
  LeaderboardLoaded(this.challenge, this.entries);
}

// Bloc
class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository _repo;
  final SharedPreferences _prefs;
  StreamSubscription<List<LeaderboardEntry>>? _leaderboardSub;

  Challenge? _currentChallenge;

  ChallengeBloc(this._repo, this._prefs) : super(ChallengeInitial()) {
    on<LoadChallenges>(_onLoad);
    on<CreateChallenge>(_onCreate);
    on<JoinByCode>(_onJoin);
    on<LeaveChallenge>(_onLeave);
    on<DeleteChallenge>(_onDelete);
    on<WatchLeaderboard>(_onWatch);
    on<_LeaderboardUpdated>(_onLeaderboardUpdated);
  }

  bool get _syncEnabled => _prefs.getBool('sync_enabled') ?? false;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;
  String get _displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';

  Future<void> _onLoad(LoadChallenges e, Emitter<ChallengeState> emit) async {
    _leaderboardSub?.cancel();
    _currentChallenge = null;
    emit(ChallengeLoading());
    // Sync: remove locally cached challenges deleted on other devices
    try {
      await _repo.syncFromRemote();
    } catch (_) {}
    final list = await _repo.getActiveChallenges();
    // Auto-deactivate ended challenges
    final now = DateTime.now();
    for (final c in list) {
      if (now.isAfter(c.endDate) && c.isActive) {
        await _repo.deactivate(c.id);
      }
    }
    final active = list.where((c) => !now.isAfter(c.endDate) || !c.isActive).toList();
    emit(ChallengesLoaded(active.isEmpty ? list : active));
  }

  Future<void> _onCreate(CreateChallenge e, Emitter<ChallengeState> emit) async {
    if (!_syncEnabled || _uid == null) {
      emit(ChallengeError('Enable cloud sync to create challenges'));
      return;
    }
    final code = _generateCode();
    final challenge = Challenge(
      id: const Uuid().v4(),
      name: e.name,
      category: e.category,
      targetMinutes: e.targetMinutes,
      startDate: e.startDate,
      endDate: e.endDate,
      inviteCode: code,
      participantLimit: e.participantLimit,
      creatorUid: _uid!,
    );
    await _repo.save(challenge);
    await _repo.joinChallenge(challenge.id, _uid!, _displayName);
    add(LoadChallenges());
  }

  Future<void> _onJoin(JoinByCode e, Emitter<ChallengeState> emit) async {
    if (!_syncEnabled || _uid == null) {
      emit(ChallengeError('Enable cloud sync to join challenges'));
      return;
    }
    final c = await _repo.getByInviteCode(e.code);
    if (c == null) {
      emit(ChallengeError('Challenge not found'));
      return;
    }
    if (!c.isActive || DateTime.now().isAfter(c.endDate)) {
      emit(ChallengeError('Challenge has ended'));
      return;
    }
    await _repo.joinChallenge(c.id, _uid!, _displayName);
    add(LoadChallenges());
  }

  Future<void> _onLeave(LeaveChallenge e, Emitter<ChallengeState> emit) async {
    if (_uid == null) return;
    await _repo.leaveChallenge(e.challengeId, _uid!);
    add(LoadChallenges());
  }

  Future<void> _onDelete(DeleteChallenge e, Emitter<ChallengeState> emit) async {
    emit(ChallengeLoading());
    try {
      await _repo.delete(e.challengeId);
    } catch (_) {}
    final list = await _repo.getActiveChallenges();
    emit(ChallengesLoaded(list));
  }

  Future<void> _onWatch(WatchLeaderboard e, Emitter<ChallengeState> emit) async {
    _leaderboardSub?.cancel();
    final c = await _repo.getById(e.challengeId);
    if (c == null) return;
    _currentChallenge = c;
    _leaderboardSub = _repo.leaderboardStream(e.challengeId).listen(
      (entries) => add(_LeaderboardUpdated(entries)),
    );
  }

  void _onLeaderboardUpdated(_LeaderboardUpdated e, Emitter<ChallengeState> emit) {
    if (_currentChallenge != null) {
      emit(LeaderboardLoaded(_currentChallenge!, e.entries));
    }
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  @override
  Future<void> close() {
    _leaderboardSub?.cancel();
    return super.close();
  }
}
