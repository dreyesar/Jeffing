import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/jeffing_step.dart';
import 'jeffing_timer_controller.dart';

class JeffingTimerScreen extends ConsumerStatefulWidget {
  final int week;

  const JeffingTimerScreen({super.key, required this.week});

  @override
  ConsumerState<JeffingTimerScreen> createState() => _JeffingTimerScreenState();
}

class _JeffingTimerScreenState extends ConsumerState<JeffingTimerScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jeffingTimerControllerProvider.notifier).setWeek(widget.week);
    });
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(jeffingTimerControllerProvider);
    final controller = ref.read(jeffingTimerControllerProvider.notifier);

    final step = timer.currentStep;
    final stepTotal = timer.stepTotalSeconds <= 0 ? 1 : timer.stepTotalSeconds;
    final remaining = timer.remainingSeconds.clamp(0, stepTotal);

    final progress01 = 1.0 - (remaining / stepTotal);

    final phaseLabel = _phaseLabel(step.phase);
    final subtitle = _subtitle(step.phase);
    final phaseColor = _phaseColor(step.phase);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Jeffing · Week ${timer.week}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            Text(
              'STEP ${timer.stepIndex + 1} OF ${timer.steps.length} · $phaseLabel',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white60,
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size =
                        math.min(constraints.maxWidth, constraints.maxHeight) *
                            0.85;

                    return SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: size,
                            height: size,
                            child: CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 12,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white.withOpacity(0.12),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size,
                            height: size,
                            child: CircularProgressIndicator(
                              value: progress01.clamp(0.0, 1.0),
                              strokeWidth: 12,
                              strokeCap: StrokeCap.round,
                              valueColor: AlwaysStoppedAnimation(phaseColor),
                            ),
                          ),
                          Text(
                            _formatMmSs(remaining),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size * 0.22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: phaseColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 56,
                  color: Colors.white,
                  icon: Icon(
                    timer.isRunning ? Icons.pause_circle : Icons.play_circle,
                  ),
                  onPressed: controller.togglePause,
                ),
                IconButton(
                  iconSize: 56,
                  color: Colors.redAccent,
                  icon: const Icon(Icons.stop_circle),
                  onPressed: () {
                    controller.stopAndReset();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static String _formatMmSs(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String _phaseLabel(JeffingPhase p) {
    switch (p) {
      case JeffingPhase.warmup:
        return 'WARM UP';
      case JeffingPhase.walk:
        return 'WALK';
      case JeffingPhase.jog:
        return 'JOG';
      case JeffingPhase.cooldown:
        return 'COOL DOWN';
    }
  }

  static String _subtitle(JeffingPhase p) {
    switch (p) {
      case JeffingPhase.warmup:
        return 'Get ready';
      case JeffingPhase.walk:
        return 'Recovery pace';
      case JeffingPhase.jog:
        return 'Easy jog';
      case JeffingPhase.cooldown:
        return 'Breathe & relax';
    }
  }

  static Color _phaseColor(JeffingPhase p) {
    switch (p) {
      case JeffingPhase.warmup:
        return Colors.amberAccent;
      case JeffingPhase.walk:
        return Colors.lightBlueAccent;
      case JeffingPhase.jog:
        return Colors.greenAccent;
      case JeffingPhase.cooldown:
        return Colors.purpleAccent;
    }
  }
}
