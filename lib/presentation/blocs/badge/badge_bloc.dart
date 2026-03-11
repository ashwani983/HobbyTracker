import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/badge.dart';
import '../../../domain/repositories/badge_repository.dart';
import '../../../domain/usecases/check_badges.dart';

// Events
abstract class BadgeEvent extends Equatable {
  const BadgeEvent();
  @override
  List<Object?> get props => [];
}

class LoadBadges extends BadgeEvent {}

class CheckNewBadges extends BadgeEvent {}

// States
abstract class BadgeState extends Equatable {
  const BadgeState();
  @override
  List<Object?> get props => [];
}

class BadgeLoading extends BadgeState {}

class BadgeLoaded extends BadgeState {
  final List<Badge> badges;
  const BadgeLoaded(this.badges);
  @override
  List<Object?> get props => [badges.where((b) => b.isUnlocked).length];
}

class NewBadgeUnlocked extends BadgeState {
  final List<Badge> newBadges;
  final List<Badge> allBadges;
  const NewBadgeUnlocked(this.newBadges, this.allBadges);
  @override
  List<Object?> get props => [newBadges.length];
}

class BadgeError extends BadgeState {
  final String message;
  const BadgeError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  final BadgeRepository _badgeRepo;
  final CheckBadges _checkBadges;

  BadgeBloc({
    required BadgeRepository badgeRepository,
    required CheckBadges checkBadges,
  })  : _badgeRepo = badgeRepository,
        _checkBadges = checkBadges,
        super(BadgeLoading()) {
    on<LoadBadges>(_onLoad);
    on<CheckNewBadges>(_onCheck);
  }

  Future<void> _onLoad(LoadBadges event, Emitter<BadgeState> emit) async {
    emit(BadgeLoading());
    try {
      final badges = await _badgeRepo.getUnlockedBadges();
      emit(BadgeLoaded(badges));
    } on DatabaseFailure catch (e) {
      emit(BadgeError(e.message));
    }
  }

  Future<void> _onCheck(CheckNewBadges event, Emitter<BadgeState> emit) async {
    try {
      final newBadges = await _checkBadges();
      final allBadges = await _badgeRepo.getUnlockedBadges();
      if (newBadges.isNotEmpty) {
        emit(NewBadgeUnlocked(newBadges, allBadges));
      }
      emit(BadgeLoaded(allBadges));
    } on DatabaseFailure catch (e) {
      emit(BadgeError(e.message));
    }
  }
}
