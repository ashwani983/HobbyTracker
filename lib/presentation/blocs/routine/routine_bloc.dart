import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/routine.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/repositories/routine_repository.dart';
import '../../../domain/usecases/log_session.dart';

// Events
abstract class RoutineEvent extends Equatable {
  const RoutineEvent();
  @override
  List<Object?> get props => [];
}

class LoadRoutines extends RoutineEvent {}

class CreateRoutineEvent extends RoutineEvent {
  final String name;
  final List<RoutineStep> steps;
  const CreateRoutineEvent({required this.name, required this.steps});
}

class DeleteRoutineEvent extends RoutineEvent {
  final String id;
  const DeleteRoutineEvent(this.id);
}

class StartRoutineEvent extends RoutineEvent {
  final Routine routine;
  const StartRoutineEvent(this.routine);
}

class AdvanceStepEvent extends RoutineEvent {}
class PauseRoutineEvent extends RoutineEvent {}
class ResumeRoutineEvent extends RoutineEvent {}
class AbortRoutineEvent extends RoutineEvent {}

class UpdateRoutineEvent extends RoutineEvent {
  final String id;
  final String name;
  final List<RoutineStep> steps;
  const UpdateRoutineEvent({required this.id, required this.name, required this.steps});
}

// States
abstract class RoutineState extends Equatable {
  const RoutineState();
  @override
  List<Object?> get props => [];
}

class RoutineInitial extends RoutineState {}

class RoutinesLoaded extends RoutineState {
  final List<Routine> routines;
  const RoutinesLoaded(this.routines);
  @override
  List<Object?> get props => [routines];
}

class RoutineRunning extends RoutineState {
  final Routine routine;
  final int currentStep;
  final Duration stepElapsed;
  final bool isPaused;
  const RoutineRunning({
    required this.routine,
    required this.currentStep,
    required this.stepElapsed,
    this.isPaused = false,
  });
  @override
  List<Object?> get props => [routine.id, currentStep, stepElapsed, isPaused];
}

class RoutineCompleted extends RoutineState {
  final Routine routine;
  final List<Duration> actualDurations;
  const RoutineCompleted({required this.routine, required this.actualDurations});
}

// Bloc
class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final RoutineRepository _repo;
  final LogSession _logSession;
  List<Duration> _stepDurations = [];
  final _stopwatch = Stopwatch();

  RoutineBloc(this._repo, this._logSession) : super(RoutineInitial()) {
    on<LoadRoutines>(_onLoad);
    on<CreateRoutineEvent>(_onCreate);
    on<UpdateRoutineEvent>(_onUpdate);
    on<DeleteRoutineEvent>(_onDelete);
    on<StartRoutineEvent>(_onStart);
    on<AdvanceStepEvent>(_onAdvance);
    on<PauseRoutineEvent>(_onPause);
    on<ResumeRoutineEvent>(_onResume);
    on<AbortRoutineEvent>(_onAbort);
  }

  Duration get liveElapsed => _stopwatch.elapsed;

  Future<void> _onLoad(LoadRoutines e, Emitter<RoutineState> emit) async {
    final routines = await _repo.getActiveRoutines();
    emit(RoutinesLoaded(routines));
  }

  Future<void> _onCreate(CreateRoutineEvent e, Emitter<RoutineState> emit) async {
    final now = DateTime.now();
    final routine = Routine(
      id: const Uuid().v4(),
      name: e.name,
      steps: e.steps,
      createdAt: now,
      updatedAt: now,
    );
    await _repo.createRoutine(routine);
    add(LoadRoutines());
  }

  Future<void> _onUpdate(UpdateRoutineEvent e, Emitter<RoutineState> emit) async {
    final existing = await _repo.getRoutineById(e.id);
    if (existing == null) return;
    final updated = Routine(
      id: e.id,
      name: e.name,
      steps: e.steps,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    await _repo.updateRoutine(updated);
    add(LoadRoutines());
  }

  Future<void> _onDelete(DeleteRoutineEvent e, Emitter<RoutineState> emit) async {
    await _repo.deleteRoutine(e.id);
    add(LoadRoutines());
  }

  void _onStart(StartRoutineEvent e, Emitter<RoutineState> emit) {
    _stepDurations = List.filled(e.routine.steps.length, Duration.zero);
    _stopwatch.reset();
    _stopwatch.start();
    emit(RoutineRunning(routine: e.routine, currentStep: 0, stepElapsed: Duration.zero));
  }

  Future<void> _onAdvance(AdvanceStepEvent e, Emitter<RoutineState> emit) async {
    if (state is! RoutineRunning) return;
    final s = state as RoutineRunning;
    _stopwatch.stop();
    _stepDurations[s.currentStep] = _stopwatch.elapsed;

    // Log session for completed step
    final step = s.routine.steps[s.currentStep];
    if (_stopwatch.elapsed.inMinutes > 0) {
      await _logSession(Session(
        id: const Uuid().v4(),
        hobbyId: step.hobbyId,
        date: DateTime.now(),
        durationMinutes: _stopwatch.elapsed.inMinutes,
        createdAt: DateTime.now(),
      ));
    }

    final next = s.currentStep + 1;
    if (next >= s.routine.steps.length) {
      emit(RoutineCompleted(routine: s.routine, actualDurations: _stepDurations));
    } else {
      _stopwatch.reset();
      _stopwatch.start();
      emit(RoutineRunning(routine: s.routine, currentStep: next, stepElapsed: Duration.zero));
    }
  }

  void _onPause(PauseRoutineEvent e, Emitter<RoutineState> emit) {
    if (state is! RoutineRunning) return;
    final s = state as RoutineRunning;
    _stopwatch.stop();
    emit(RoutineRunning(
      routine: s.routine,
      currentStep: s.currentStep,
      stepElapsed: _stopwatch.elapsed,
      isPaused: true,
    ));
  }

  void _onResume(ResumeRoutineEvent e, Emitter<RoutineState> emit) {
    if (state is! RoutineRunning) return;
    final s = state as RoutineRunning;
    _stopwatch.start();
    emit(RoutineRunning(
      routine: s.routine,
      currentStep: s.currentStep,
      stepElapsed: _stopwatch.elapsed,
    ));
  }

  Future<void> _onAbort(AbortRoutineEvent e, Emitter<RoutineState> emit) async {
    if (state is! RoutineRunning) return;
    final s = state as RoutineRunning;
    _stopwatch.stop();
    _stepDurations[s.currentStep] = _stopwatch.elapsed;

    // Log sessions for all completed steps
    for (var i = 0; i <= s.currentStep; i++) {
      if (_stepDurations[i].inMinutes > 0) {
        await _logSession(Session(
          id: const Uuid().v4(),
          hobbyId: s.routine.steps[i].hobbyId,
          date: DateTime.now(),
          durationMinutes: _stepDurations[i].inMinutes,
          createdAt: DateTime.now(),
        ));
      }
    }
    add(LoadRoutines());
  }

  @override
  Future<void> close() {
    _stopwatch.stop();
    return super.close();
  }
}
