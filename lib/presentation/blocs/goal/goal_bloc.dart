import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/goal.dart';
import '../../../domain/usecases/create_goal.dart';
import '../../../domain/usecases/deactivate_goal.dart';
import '../../../domain/usecases/get_active_goals.dart';
import '../../../domain/usecases/update_goal.dart';

// Events
abstract class GoalEvent extends Equatable {
  const GoalEvent();
  @override
  List<Object?> get props => [];
}

class LoadGoals extends GoalEvent {}

class CreateGoalEvent extends GoalEvent {
  final Goal goal;
  const CreateGoalEvent(this.goal);
  @override
  List<Object?> get props => [goal.id];
}

class DeactivateGoalEvent extends GoalEvent {
  final String goalId;
  const DeactivateGoalEvent(this.goalId);
  @override
  List<Object?> get props => [goalId];
}

class UpdateGoalEvent extends GoalEvent {
  final Goal goal;
  const UpdateGoalEvent(this.goal);
  @override
  List<Object?> get props => [goal.id];
}

// States
abstract class GoalState extends Equatable {
  const GoalState();
  @override
  List<Object?> get props => [];
}

class GoalLoading extends GoalState {}

class GoalLoaded extends GoalState {
  final List<Goal> goals;
  final int _stamp;
  GoalLoaded(this.goals) : _stamp = DateTime.now().microsecondsSinceEpoch;
  @override
  List<Object?> get props => [_stamp, goals];
}

class GoalEmpty extends GoalState {}

class GoalError extends GoalState {
  final String message;
  const GoalError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GetActiveGoals _getActiveGoals;
  final CreateGoal _createGoal;
  final UpdateGoal _updateGoal;
  final DeactivateGoal _deactivateGoal;

  GoalBloc({
    required GetActiveGoals getActiveGoals,
    required CreateGoal createGoal,
    required UpdateGoal updateGoal,
    required DeactivateGoal deactivateGoal,
  })  : _getActiveGoals = getActiveGoals,
        _createGoal = createGoal,
        _updateGoal = updateGoal,
        _deactivateGoal = deactivateGoal,
        super(GoalLoading()) {
    on<LoadGoals>(_onLoad);
    on<CreateGoalEvent>(_onCreate);
    on<UpdateGoalEvent>(_onUpdate);
    on<DeactivateGoalEvent>(_onDeactivate);
  }

  Future<void> _onLoad(LoadGoals event, Emitter<GoalState> emit) async {
    emit(GoalLoading());
    try {
      final goals = await _getActiveGoals();
      emit(goals.isEmpty ? GoalEmpty() : GoalLoaded(goals));
    } on DatabaseFailure catch (e) {
      emit(GoalError(e.message));
    }
  }

  Future<void> _onCreate(
    CreateGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await _createGoal(event.goal);
      add(LoadGoals());
    } on ValidationFailure catch (e) {
      emit(GoalError(e.message));
    } on DatabaseFailure catch (e) {
      emit(GoalError(e.message));
    }
  }

  Future<void> _onDeactivate(
    DeactivateGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await _deactivateGoal(event.goalId);
      add(LoadGoals());
    } on DatabaseFailure catch (e) {
      emit(GoalError(e.message));
    }
  }

  Future<void> _onUpdate(
    UpdateGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await _updateGoal(event.goal);
      add(LoadGoals());
    } on ValidationFailure catch (e) {
      emit(GoalError(e.message));
    } on DatabaseFailure catch (e) {
      emit(GoalError(e.message));
    }
  }
}
