import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class TimerState extends Equatable {
  final Duration elapsed;
  const TimerState(this.elapsed);
  @override
  List<Object?> get props => [elapsed];
}

class TimerInitial extends TimerState {
  const TimerInitial() : super(Duration.zero);
}

class TimerRunning extends TimerState {
  const TimerRunning(super.elapsed);
}

class TimerPaused extends TimerState {
  const TimerPaused(super.elapsed);
}

class TimerStopped extends TimerState {
  const TimerStopped(super.elapsed);
}

// Cubit
class TimerCubit extends Cubit<TimerState> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  TimerCubit() : super(const TimerInitial());

  void start() {
    _stopwatch.reset();
    _stopwatch.start();
    _startTicker();
    emit(TimerRunning(_stopwatch.elapsed));
  }

  void pause() {
    _stopwatch.stop();
    _ticker?.cancel();
    emit(TimerPaused(_stopwatch.elapsed));
  }

  void resume() {
    _stopwatch.start();
    _startTicker();
    emit(TimerRunning(_stopwatch.elapsed));
  }

  void stop() {
    _stopwatch.stop();
    _ticker?.cancel();
    emit(TimerStopped(_stopwatch.elapsed));
  }

  void discard() {
    _stopwatch
      ..stop()
      ..reset();
    _ticker?.cancel();
    emit(const TimerInitial());
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(TimerRunning(_stopwatch.elapsed));
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    _stopwatch.stop();
    return super.close();
  }
}
