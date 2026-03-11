import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/usecases/get_stats.dart';

// Events
abstract class StatsEvent extends Equatable {
  const StatsEvent();
  @override
  List<Object?> get props => [];
}

class LoadStats extends StatsEvent {}

class ChangeTimePeriod extends StatsEvent {
  final TimePeriod period;
  const ChangeTimePeriod(this.period);
  @override
  List<Object?> get props => [period];
}

enum TimePeriod { week, month, year }

// States
abstract class StatsState extends Equatable {
  const StatsState();
  @override
  List<Object?> get props => [];
}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final StatsResult data;
  final TimePeriod period;
  const StatsLoaded({required this.data, required this.period});
  @override
  List<Object?> get props => [period, data.perHobbyDurations.length];
}

class StatsEmpty extends StatsState {}

class StatsError extends StatsState {
  final String message;
  const StatsError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetStats _getStats;
  TimePeriod _currentPeriod = TimePeriod.week;

  StatsBloc({required GetStats getStats})
      : _getStats = getStats,
        super(StatsLoading()) {
    on<LoadStats>(_onLoad);
    on<ChangeTimePeriod>(_onChangePeriod);
  }

  Future<void> _onLoad(LoadStats event, Emitter<StatsState> emit) async {
    await _loadStats(emit);
  }

  Future<void> _onChangePeriod(
    ChangeTimePeriod event,
    Emitter<StatsState> emit,
  ) async {
    _currentPeriod = event.period;
    await _loadStats(emit);
  }

  Future<void> _loadStats(Emitter<StatsState> emit) async {
    emit(StatsLoading());
    try {
      final range = _dateRange(_currentPeriod);
      final result = await _getStats(range.$1, range.$2);
      if (result.perHobbyDurations.isEmpty) {
        emit(StatsEmpty());
      } else {
        emit(StatsLoaded(data: result, period: _currentPeriod));
      }
    } on DatabaseFailure catch (e) {
      emit(StatsError(e.message));
    }
  }

  (DateTime, DateTime) _dateRange(TimePeriod period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (period) {
      case TimePeriod.week:
        final start = today.subtract(Duration(days: now.weekday - 1));
        return (start, now);
      case TimePeriod.month:
        final start = DateTime(now.year, now.month);
        return (start, now);
      case TimePeriod.year:
        final start = DateTime(now.year);
        return (start, now);
    }
  }
}
