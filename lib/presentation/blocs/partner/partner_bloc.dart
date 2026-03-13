import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/partner.dart';
import '../../../domain/repositories/partner_repository.dart';

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
  String? _lastInviteCode;

  PartnerBloc({required PartnerRepository repo})
      : _repo = repo,
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
      emit(PartnersLoaded(partners, stats, inviteCode: _lastInviteCode));
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
      _lastInviteCode = code;
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
}
