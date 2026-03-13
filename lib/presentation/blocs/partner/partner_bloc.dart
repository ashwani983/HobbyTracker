import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/partner.dart';
import '../../../domain/repositories/goal_repository.dart';
import '../../../domain/repositories/partner_repository.dart';
import '../../../domain/repositories/session_repository.dart';

// Events
abstract class PartnerEvent {}

class LoadPartners extends PartnerEvent {}

class SendPartnerRequest extends PartnerEvent {}

class AcceptPartnerRequest extends PartnerEvent {
  final String inviteCode;
  AcceptPartnerRequest(this.inviteCode);
}

class RemovePartner extends PartnerEvent {
  final String partnerId;
  RemovePartner(this.partnerId);
}

// States
abstract class PartnerState {}

class PartnerInitial extends PartnerState {}

class PartnerLoading extends PartnerState {}

class PartnersLoaded extends PartnerState {
  final List<Partner> partners;
  final List<PartnerStats> stats;
  final String? inviteCode;
  PartnersLoaded(this.partners, this.stats, {this.inviteCode});
}

class PartnerError extends PartnerState {
  final String message;
  PartnerError(this.message);
}

// Bloc
class PartnerBloc extends Bloc<PartnerEvent, PartnerState> {
  final PartnerRepository _repo;
  final SessionRepository _sessionRepo;
  final GoalRepository _goalRepo;

  PartnerBloc({
    required PartnerRepository repo,
    required SessionRepository sessionRepo,
    required GoalRepository goalRepo,
  })  : _repo = repo,
        _sessionRepo = sessionRepo,
        _goalRepo = goalRepo,
        super(PartnerInitial()) {
    on<LoadPartners>(_onLoad);
    on<SendPartnerRequest>(_onSend);
    on<AcceptPartnerRequest>(_onAccept);
    on<RemovePartner>(_onRemove);
  }

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;
  String get _displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? 'User';

  Future<void> _onLoad(LoadPartners e, Emitter<PartnerState> emit) async {
    emit(PartnerLoading());
    try {
      if (_uid != null) {
        try { await _repo.syncFromRemote(_uid!); } catch (_) {}
        try { await _publishMyStats(); } catch (_) {}
      }
      final partners = await _repo.getActivePartners();
      final stats = <PartnerStats>[];
      for (final p in partners) {
        try {
          stats.add(await _repo.getPartnerStats(p.partnerUid));
        } catch (_) {
          stats.add(PartnerStats(
            partnerUid: p.partnerUid,
            displayName: p.partnerDisplayName,
          ));
        }
      }
      emit(PartnersLoaded(partners, stats));
    } catch (e) {
      emit(PartnerError(e.toString()));
    }
  }

  Future<void> _onSend(SendPartnerRequest e, Emitter<PartnerState> emit) async {
    if (_uid == null) {
      emit(PartnerError('Enable cloud sync to use partners'));
      return;
    }
    try {
      final code = await _repo.sendRequest(_uid!, _displayName);
      final partners = await _repo.getActivePartners();
      final stats = <PartnerStats>[];
      for (final p in partners) {
        try {
          stats.add(await _repo.getPartnerStats(p.partnerUid));
        } catch (_) {
          stats.add(PartnerStats(partnerUid: p.partnerUid, displayName: p.partnerDisplayName));
        }
      }
      emit(PartnersLoaded(partners, stats, inviteCode: code));
    } catch (e) {
      emit(PartnerError(e.toString()));
    }
  }

  Future<void> _onAccept(AcceptPartnerRequest e, Emitter<PartnerState> emit) async {
    if (_uid == null) {
      emit(PartnerError('Enable cloud sync to use partners'));
      return;
    }
    try {
      await _repo.acceptRequest(e.inviteCode, _uid!, _displayName);
      add(LoadPartners());
    } catch (err) {
      emit(PartnerError(err.toString()));
    }
  }

  Future<void> _onRemove(RemovePartner e, Emitter<PartnerState> emit) async {
    if (_uid == null) return;
    emit(PartnerLoading());
    try {
      await _repo.removePartner(e.partnerId, _uid!);
    } catch (_) {}
    final partners = await _repo.getActivePartners();
    final stats = <PartnerStats>[];
    for (final p in partners) {
      try {
        stats.add(await _repo.getPartnerStats(p.partnerUid));
      } catch (_) {
        stats.add(PartnerStats(
          partnerUid: p.partnerUid,
          displayName: p.partnerDisplayName,
        ));
      }
    }
    emit(PartnersLoaded(partners, stats));
  }

  Future<void> _publishMyStats() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final sessions = await _sessionRepo.getSessionsInRange(weekAgo, now);
    final weeklyMinutes = sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);

    // Simple streak: count consecutive days with sessions going back from today
    int streak = 0;
    for (int i = 0; i < 365; i++) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final dayEnd = day.add(const Duration(days: 1));
      final daySessions = await _sessionRepo.getSessionsInRange(day, dayEnd);
      if (daySessions.isEmpty) break;
      streak++;
    }

    // Goal completion
    final goals = await _goalRepo.getActiveGoals();
    int goalPercent = 0;
    if (goals.isNotEmpty) {
      int completed = 0;
      for (final g in goals) {
        final total = await _sessionRepo.getTotalDurationForHobbyInRange(
            g.hobbyId, g.startDate, g.endDate);
        if (total >= g.targetDurationMinutes) completed++;
      }
      goalPercent = ((completed / goals.length) * 100).round();
    }

    await _repo.publishMyStats(_uid!, _displayName, streak, weeklyMinutes, goalPercent);
  }
}
