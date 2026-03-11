import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/hobby.dart';
import '../../../domain/usecases/archive_hobby.dart';
import '../../../domain/usecases/create_hobby.dart';
import '../../../domain/usecases/get_active_hobbies.dart';

// Events
abstract class HobbyListEvent extends Equatable {
  const HobbyListEvent();
  @override
  List<Object?> get props => [];
}

class LoadHobbies extends HobbyListEvent {}

class CreateHobbyEvent extends HobbyListEvent {
  final Hobby hobby;
  const CreateHobbyEvent(this.hobby);
  @override
  List<Object?> get props => [hobby.id];
}

class ArchiveHobbyEvent extends HobbyListEvent {
  final String hobbyId;
  const ArchiveHobbyEvent(this.hobbyId);
  @override
  List<Object?> get props => [hobbyId];
}

// States
abstract class HobbyListState extends Equatable {
  const HobbyListState();
  @override
  List<Object?> get props => [];
}

class HobbyListLoading extends HobbyListState {}

class HobbyListLoaded extends HobbyListState {
  final List<Hobby> hobbies;
  const HobbyListLoaded(this.hobbies);
  @override
  List<Object?> get props => [hobbies];
}

class HobbyListEmpty extends HobbyListState {}

class HobbyListError extends HobbyListState {
  final String message;
  const HobbyListError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class HobbyListBloc extends Bloc<HobbyListEvent, HobbyListState> {
  final GetActiveHobbies _getActiveHobbies;
  final CreateHobby _createHobby;
  final ArchiveHobby _archiveHobby;

  HobbyListBloc({
    required GetActiveHobbies getActiveHobbies,
    required CreateHobby createHobby,
    required ArchiveHobby archiveHobby,
  })  : _getActiveHobbies = getActiveHobbies,
        _createHobby = createHobby,
        _archiveHobby = archiveHobby,
        super(HobbyListLoading()) {
    on<LoadHobbies>(_onLoad);
    on<CreateHobbyEvent>(_onCreate);
    on<ArchiveHobbyEvent>(_onArchive);
  }

  Future<void> _onLoad(LoadHobbies event, Emitter<HobbyListState> emit) async {
    emit(HobbyListLoading());
    try {
      final hobbies = await _getActiveHobbies();
      emit(hobbies.isEmpty ? HobbyListEmpty() : HobbyListLoaded(hobbies));
    } on DatabaseFailure catch (e) {
      emit(HobbyListError(e.message));
    }
  }

  Future<void> _onCreate(
    CreateHobbyEvent event,
    Emitter<HobbyListState> emit,
  ) async {
    try {
      await _createHobby(event.hobby);
      add(LoadHobbies());
    } on ValidationFailure catch (e) {
      emit(HobbyListError(e.message));
    } on DatabaseFailure catch (e) {
      emit(HobbyListError(e.message));
    }
  }

  Future<void> _onArchive(
    ArchiveHobbyEvent event,
    Emitter<HobbyListState> emit,
  ) async {
    try {
      await _archiveHobby(event.hobbyId);
      add(LoadHobbies());
    } on DatabaseFailure catch (e) {
      emit(HobbyListError(e.message));
    }
  }
}
