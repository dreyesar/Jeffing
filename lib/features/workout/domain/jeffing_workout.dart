import 'jeffing_plan.dart';
import 'jeffing_step.dart';

class JeffingWorkout {
  final int week;
  final List<JeffingStep> steps;
  final String summary;

  const JeffingWorkout({
    required this.week,
    required this.steps,
    required this.summary,
  });

  factory JeffingWorkout.forWeek(int week) {
    final plan = JeffingPlans.forWeek(week);
    return JeffingWorkout(
      week: plan.week,
      steps: plan.buildSteps(),
      summary: plan.summaryLine,
    );
  }
}
