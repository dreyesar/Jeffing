import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/jeffing_step.dart';
import '../domain/jeffing_workout.dart';

final jeffingTimerControllerProvider =
    NotifierProvider<JeffingTimerController, JeffingTimerState>(
  JeffingTimerController.new,
);

class JeffingTimerState {
  final JeffingWorkout workout;
  final int stepIndex;
  final int remainingSeconds;
  final bool isRunning;
  final bool isFinished;

  const JeffingTimerState({
    required this.workout,
    required this.stepIndex,
    required this.remainingSeconds,
    required this.isRunning,
    required this.isFinished,
  });

  int get week => workout.week;
  List<JeffingStep> get steps => workout.steps;

  JeffingStep get currentStep => steps[stepIndex];
  int get stepTotalSeconds => currentStep.seconds;

  JeffingTimerState copyWith({
    JeffingWorkout? workout,
    int? stepIndex,
    int? remainingSeconds,
    bool? isRunning,
    bool? isFinished,
  }) {
    return JeffingTimerState(
      workout: workout ?? this.workout,
      stepIndex: stepIndex ?? this.stepIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class JeffingTimerController extends Notifier<JeffingTimerState> {
  Timer? _timer;

  @override
  JeffingTimerState build() {
    final workout = JeffingWorkout.forWeek(1);
    return JeffingTimerState(
      workout: workout,
      stepIndex: 0,
      remainingSeconds: workout.steps.first.seconds,
      isRunning: false,
      isFinished: false,
    );
  }

  void setWeek(int week) {
    final workout = JeffingWorkout.forWeek(week);
    _timer?.cancel();
    _timer = null;

    state = JeffingTimerState(
      workout: workout,
      stepIndex: 0,
      remainingSeconds: workout.steps.first.seconds,
      isRunning: false,
      isFinished: false,
    );
  }

  void togglePause() {
    if (state.isFinished) return;

    if (state.isRunning) {
      _timer?.cancel();
      _timer = null;
      state = state.copyWith(isRunning: false);
      return;
    }

    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    state = state.copyWith(isRunning: true);
  }

  void stopAndReset() {
    _timer?.cancel();
    _timer = null;

    state = state.copyWith(
      stepIndex: 0,
      remainingSeconds: state.steps.first.seconds,
      isRunning: false,
      isFinished: false,
    );
  }

  void _tick() {
    if (!state.isRunning || state.isFinished) return;

    if (state.remainingSeconds > 1) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      return;
    }

    // move to next step
    if (state.stepIndex >= state.steps.length - 1) {
      _timer?.cancel();
      _timer = null;
      state = state.copyWith(
        remainingSeconds: 0,
        isRunning: false,
        isFinished: true,
      );
      return;
    }

    final nextIndex = state.stepIndex + 1;
    final nextSeconds = state.steps[nextIndex].seconds;

    state = state.copyWith(
      stepIndex: nextIndex,
      remainingSeconds: nextSeconds,
    );
  }

  void onDispose() {
    _timer?.cancel();
    _timer = null;
  }

}
