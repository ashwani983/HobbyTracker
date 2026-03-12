enum TimerMode { stopwatch, countdown, pomodoro }

class PomodoroConfig {
  final int focusMinutes;
  final int breakMinutes;
  final int longBreakMinutes;
  final int intervalsBeforeLongBreak;

  const PomodoroConfig({
    this.focusMinutes = 25,
    this.breakMinutes = 5,
    this.longBreakMinutes = 15,
    this.intervalsBeforeLongBreak = 4,
  });
}
