import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressState {
  final int selectedWeek;
  final int totalSeconds;
  final int elapsedSeconds;

  const ProgressState({
    required this.selectedWeek,
    required this.totalSeconds,
    required this.elapsedSeconds,
  });

  double get progress01 {
    if (totalSeconds <= 0) return 0;
    return (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  ProgressState copyWith({
    int? selectedWeek,
    int? totalSeconds,
    int? elapsedSeconds,
  }) {
    return ProgressState(
      selectedWeek: selectedWeek ?? this.selectedWeek,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
}

class ProgressController extends Notifier<ProgressState> {
  @override
  ProgressState build() {
    return const ProgressState(
      selectedWeek: 1,
      totalSeconds: 0,
      elapsedSeconds: 0,
    );
  }

  void setSelectedWeek(int week) {
    state = state.copyWith(selectedWeek: week);
  }

  void setTotalSeconds(int total) {
    state = state.copyWith(totalSeconds: total);
  }

  void setElapsedSeconds(int elapsed) {
    state = state.copyWith(elapsedSeconds: elapsed);
  }

  void resetWorkoutProgress() {
    state = state.copyWith(totalSeconds: 0, elapsedSeconds: 0);
  }
}

final progressControllerProvider =
    NotifierProvider<ProgressController, ProgressState>(ProgressController.new);
