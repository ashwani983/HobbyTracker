import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/timer_config.dart';

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
  final TimerMode mode;
  final Duration? remaining; // countdown/pomodoro
  final int? pomodoroInterval; // current focus interval (1-based)
  final bool? isBreak; // pomodoro break phase
  const TimerRunning(
    super.elapsed, {
    this.mode = TimerMode.stopwatch,
    this.remaining,
    this.pomodoroInterval,
    this.isBreak,
  });
  @override
  List<Object?> get props =>
      [elapsed, mode, remaining, pomodoroInterval, isBreak];
}

class TimerPaused extends TimerState {
  final TimerMode mode;
  final Duration? remaining;
  final int? pomodoroInterval;
  final bool? isBreak;
  const TimerPaused(
    super.elapsed, {
    this.mode = TimerMode.stopwatch,
    this.remaining,
    this.pomodoroInterval,
    this.isBreak,
  });
  @override
  List<Object?> get props =>
      [elapsed, mode, remaining, pomodoroInterval, isBreak];
}

class TimerStopped extends TimerState {
  const TimerStopped(super.elapsed);
}

/// Emitted when a pomodoro focus interval ends — UI should prompt break.
class PomodoroBreakPrompt extends TimerState {
  final int completedIntervals;
  final bool isLongBreak;
  const PomodoroBreakPrompt(
    super.elapsed, {
    required this.completedIntervals,
    required this.isLongBreak,
  });
  @override
  List<Object?> get props => [elapsed, completedIntervals, isLongBreak];
}

// Cubit
class TimerCubit extends Cubit<TimerState> {
  final SharedPreferences _prefs;
  final Stopwatch _stopwatch = Stopwatch();
  AudioPlayer? _audio;
  Timer? _ticker;

  TimerMode _mode = TimerMode.stopwatch;
  Duration _countdownTarget = const Duration(minutes: 10);
  PomodoroConfig _pomodoroConfig = const PomodoroConfig();
  int _pomodoroInterval = 0; // completed focus intervals
  bool _isBreak = false;
  Duration _phaseElapsed = Duration.zero; // elapsed within current phase

  TimerCubit(this._prefs) : super(const TimerInitial()) {
    _loadPomodoroPrefs();
  }

  TimerMode get mode => _mode;
  PomodoroConfig get pomodoroConfig => _pomodoroConfig;
  Duration get countdownTarget => _countdownTarget;

  void setMode(TimerMode m) => _mode = m;
  void setCountdownDuration(Duration d) => _countdownTarget = d;

  void configurePomodoroAndSave(PomodoroConfig config) {
    _pomodoroConfig = config;
    _prefs.setInt('pomo_focus', config.focusMinutes);
    _prefs.setInt('pomo_break', config.breakMinutes);
    _prefs.setInt('pomo_long_break', config.longBreakMinutes);
    _prefs.setInt('pomo_intervals', config.intervalsBeforeLongBreak);
  }

  void _loadPomodoroPrefs() {
    _pomodoroConfig = PomodoroConfig(
      focusMinutes: _prefs.getInt('pomo_focus') ?? 25,
      breakMinutes: _prefs.getInt('pomo_break') ?? 5,
      longBreakMinutes: _prefs.getInt('pomo_long_break') ?? 15,
      intervalsBeforeLongBreak: _prefs.getInt('pomo_intervals') ?? 4,
    );
  }

  void start() {
    _stopwatch.reset();
    _stopwatch.start();
    _pomodoroInterval = 0;
    _isBreak = false;
    _phaseElapsed = Duration.zero;
    _startTicker();
    _emitRunning();
  }

  void pause() {
    _stopwatch.stop();
    _ticker?.cancel();
    emit(TimerPaused(
      _stopwatch.elapsed,
      mode: _mode,
      remaining: _remaining(),
      pomodoroInterval: _mode == TimerMode.pomodoro ? _pomodoroInterval + 1 : null,
      isBreak: _mode == TimerMode.pomodoro ? _isBreak : null,
    ));
  }

  void resume() {
    _stopwatch.start();
    _startTicker();
    _emitRunning();
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

  /// Called by UI after pomodoro break prompt to start the break timer.
  void startBreak() {
    _isBreak = true;
    _phaseElapsed = Duration.zero;
    _stopwatch.start();
    _startTicker();
    _emitRunning();
  }

  /// Called by UI to skip break and start next focus interval.
  void skipBreak() {
    _isBreak = false;
    _phaseElapsed = Duration.zero;
    _stopwatch.start();
    _startTicker();
    _emitRunning();
  }

  Duration? _remaining() {
    if (_mode == TimerMode.countdown) {
      final r = _countdownTarget - _stopwatch.elapsed;
      return r.isNegative ? Duration.zero : r;
    }
    if (_mode == TimerMode.pomodoro) {
      final phaseTarget = _isBreak
          ? (_pomodoroInterval % _pomodoroConfig.intervalsBeforeLongBreak == 0
              ? Duration(minutes: _pomodoroConfig.longBreakMinutes)
              : Duration(minutes: _pomodoroConfig.breakMinutes))
          : Duration(minutes: _pomodoroConfig.focusMinutes);
      final r = phaseTarget - _phaseElapsed;
      return r.isNegative ? Duration.zero : r;
    }
    return null;
  }

  void _emitRunning() {
    emit(TimerRunning(
      _stopwatch.elapsed,
      mode: _mode,
      remaining: _remaining(),
      pomodoroInterval: _mode == TimerMode.pomodoro ? _pomodoroInterval + 1 : null,
      isBreak: _mode == TimerMode.pomodoro ? _isBreak : null,
    ));
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _phaseElapsed += const Duration(seconds: 1);

      if (_mode == TimerMode.countdown) {
        final r = _countdownTarget - _stopwatch.elapsed;
        if (r <= Duration.zero) {
          _stopwatch.stop();
          _ticker?.cancel();
          _playAlarm();
          emit(TimerStopped(_stopwatch.elapsed));
          return;
        }
      }

      if (_mode == TimerMode.pomodoro) {
        final phaseTarget = _isBreak
            ? (_pomodoroInterval % _pomodoroConfig.intervalsBeforeLongBreak == 0
                ? Duration(minutes: _pomodoroConfig.longBreakMinutes)
                : Duration(minutes: _pomodoroConfig.breakMinutes))
            : Duration(minutes: _pomodoroConfig.focusMinutes);

        if (_phaseElapsed >= phaseTarget) {
          _stopwatch.stop();
          _ticker?.cancel();
          _playAlarm();

          if (_isBreak) {
            // Break ended — start next focus
            _isBreak = false;
            _phaseElapsed = Duration.zero;
            _stopwatch.start();
            _startTicker();
            _emitRunning();
          } else {
            // Focus ended — prompt break
            _pomodoroInterval++;
            _phaseElapsed = Duration.zero;
            final isLong = _pomodoroInterval %
                    _pomodoroConfig.intervalsBeforeLongBreak ==
                0;
            emit(PomodoroBreakPrompt(
              _stopwatch.elapsed,
              completedIntervals: _pomodoroInterval,
              isLongBreak: isLong,
            ));
          }
          return;
        }
      }

      _emitRunning();
    });
  }

  Future<void> _playAlarm() async {
    try {
      _audio ??= AudioPlayer();
      await _audio!.play(AssetSource('sounds/alarm.mp3'));
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    _stopwatch.stop();
    _audio?.dispose();
    return super.close();
  }
}
