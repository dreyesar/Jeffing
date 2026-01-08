enum JeffingPhase { warmup, walk, jog, cooldown }

class JeffingStep {
  final JeffingPhase phase;
  final int seconds;

  const JeffingStep({
    required this.phase,
    required this.seconds,
  });
}
