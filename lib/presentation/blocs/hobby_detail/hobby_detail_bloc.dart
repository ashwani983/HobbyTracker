import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/hobby.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/repositories/hobby_repository.dart';
import '../../../domain/usecases/get_sessions_by_hobby.dart';

// Events
abstract class HobbyDetailEvent extends Equatable {
  const HobbyDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadHobbyDetail extends HobbyDetailEvent {
  final String hobbyId;
  const LoadHobbyDetail(this.hobbyId);
  @override
  List<Object?> get props => [hobbyId];
}

// States
abstract class HobbyDetailState extends Equatable {
  const HobbyDetailState();
  @override
  List<Object?> get props => [];
}

class HobbyDetailLoading extends HobbyDetailState {}

class HobbyDetailLoaded extends HobbyDetailState {
  final Hobby hobby;
  final List<Session> sessions;
  const HobbyDetailLoaded({required this.hobby, required this.sessions});
  @override
  List<Object?> get props => [hobby.id, sessions.length];
}

class HobbyDetailError extends HobbyDetailState {
  final String message;
  const HobbyDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class HobbyDetailBloc extends Bloc<HobbyDetailEvent, HobbyDetailState> {
  final HobbyRepository _hobbyRepository;
  final GetSessionsByHobby _getSessionsByHobby;

  HobbyDetailBloc({
    required HobbyRepository hobbyRepository,
    required GetSessionsByHobby getSessionsByHobby,
  })  : _hobbyRepository = hobbyRepository,
        _getSessionsByHobby = getSessionsByHobby,
        super(HobbyDetailLoading()) {
    on<LoadHobbyDetail>(_onLoad);
  }

  Future<void> _onLoad(
    LoadHobbyDetail event,
    Emitter<HobbyDetailState> emit,
  ) async {
    emit(HobbyDetailLoading());
    try {
      final hobby = await _hobbyRepository.getHobbyById(event.hobbyId);
      if (hobby == null) {
        emit(const HobbyDetailError('Hobby not found'));
        return;
      }
      final sessions = await _getSessionsByHobby(event.hobbyId);
      emit(HobbyDetailLoaded(hobby: hobby, sessions: sessions));
    } on DatabaseFailure catch (e) {
      emit(HobbyDetailError(e.message));
    }
  }
}
