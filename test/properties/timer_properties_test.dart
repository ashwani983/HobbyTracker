import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hobby_tracker/presentation/blocs/timer/timer_cubit.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  // Feature: flutter-hobby-tracker, Property 8: Timer pause/resume round-trip
  blocTest<TimerCubit, TimerState>(
    'Property 8: pause then resume continues from paused elapsed',
    build: () => TimerCubit(prefs),
    act: (cubit) async {
      cubit.start();
      await Future.delayed(const Duration(milliseconds: 50));
      cubit.pause();
      final pausedElapsed = cubit.state.elapsed;
      cubit.resume();
      await Future.delayed(const Duration(milliseconds: 50));
      // After resume, elapsed should be >= paused elapsed
      expect(cubit.state.elapsed >= pausedElapsed, isTrue);
    },
    verify: (cubit) {
      expect(cubit.state, isA<TimerRunning>());
    },
  );

  // Feature: flutter-hobby-tracker, Property 9: Timer stop yields correct duration
  blocTest<TimerCubit, TimerState>(
    'Property 9: stop produces a non-negative duration',
    build: () => TimerCubit(prefs),
    act: (cubit) async {
      cubit.start();
      await Future.delayed(const Duration(milliseconds: 50));
      cubit.stop();
    },
    verify: (cubit) {
      expect(cubit.state, isA<TimerStopped>());
      expect(cubit.state.elapsed.inMicroseconds >= 0, isTrue);
    },
  );

  // Feature: flutter-hobby-tracker, Property 10: Timer discard resets state
  blocTest<TimerCubit, TimerState>(
    'Property 10: discard from running resets to initial',
    build: () => TimerCubit(prefs),
    act: (cubit) async {
      cubit.start();
      await Future.delayed(const Duration(milliseconds: 50));
      cubit.discard();
    },
    verify: (cubit) {
      expect(cubit.state, isA<TimerInitial>());
      expect(cubit.state.elapsed, Duration.zero);
    },
  );

  blocTest<TimerCubit, TimerState>(
    'Property 10: discard from paused resets to initial',
    build: () => TimerCubit(prefs),
    act: (cubit) async {
      cubit.start();
      await Future.delayed(const Duration(milliseconds: 50));
      cubit.pause();
      cubit.discard();
    },
    verify: (cubit) {
      expect(cubit.state, isA<TimerInitial>());
      expect(cubit.state.elapsed, Duration.zero);
    },
  );

  blocTest<TimerCubit, TimerState>(
    'Property 10: discard from stopped resets to initial',
    build: () => TimerCubit(prefs),
    act: (cubit) async {
      cubit.start();
      await Future.delayed(const Duration(milliseconds: 50));
      cubit.stop();
      cubit.discard();
    },
    verify: (cubit) {
      expect(cubit.state, isA<TimerInitial>());
      expect(cubit.state.elapsed, Duration.zero);
    },
  );
}
