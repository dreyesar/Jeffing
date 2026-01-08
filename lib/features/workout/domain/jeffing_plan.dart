import 'jeffing_step.dart';

class JeffingWeekPlan {
  final int week; // 1..4
  final int warmupSeconds;
  final int cooldownSeconds;
  final int walkSeconds;
  final int jogSeconds;
  final int rounds;

  const JeffingWeekPlan({
    required this.week,
    required this.warmupSeconds,
    required this.cooldownSeconds,
    required this.walkSeconds,
    required this.jogSeconds,
    required this.rounds,
  });

  List<JeffingStep> buildSteps() {
    final steps = <JeffingStep>[
      JeffingStep(phase: JeffingPhase.warmup, seconds: warmupSeconds),
    ];

    for (var i = 0; i < rounds; i++) {
      steps.add(JeffingStep(phase: JeffingPhase.jog, seconds: jogSeconds));
      steps.add(JeffingStep(phase: JeffingPhase.walk, seconds: walkSeconds));
    }

    steps.add(JeffingStep(phase: JeffingPhase.cooldown, seconds: cooldownSeconds));
    return steps;
  }

  String get summaryLine =>
      'Warm up ${_mmss(warmupSeconds)} · ${rounds} rounds · Jog ${_mmss(jogSeconds)} / Walk ${_mmss(walkSeconds)} · Cool down ${_mmss(cooldownSeconds)}';

  static String _mmss(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class JeffingPlans {
  static JeffingWeekPlan forWeek(int week) {
    switch (week) {
      case 1:
        return const JeffingWeekPlan(
          week: 1,
          warmupSeconds: 5 * 60,
          cooldownSeconds: 5 * 60,
          walkSeconds: 60,
          jogSeconds: 30,
          rounds: 10,
        );
      case 2:
        return const JeffingWeekPlan(
          week: 2,
          warmupSeconds: 5 * 60,
          cooldownSeconds: 5 * 60,
          walkSeconds: 60,
          jogSeconds: 45,
          rounds: 10,
        );
      case 3:
        return const JeffingWeekPlan(
          week: 3,
          warmupSeconds: 5 * 60,
          cooldownSeconds: 5 * 60,
          walkSeconds: 60,
          jogSeconds: 60,
          rounds: 10,
        );
      case 4:
      default:
        return const JeffingWeekPlan(
          week: 4,
          warmupSeconds: 5 * 60,
          cooldownSeconds: 5 * 60,
          walkSeconds: 45,
          jogSeconds: 75,
          rounds: 10,
        );
    }
  }
}
