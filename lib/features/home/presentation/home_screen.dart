import 'package:flutter/material.dart';

import '../../workout/presentation/jeffing_timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedWeek = 1;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeffing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pick your week',
              style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [1, 2, 3, 4].map((w) {
                final selected = w == _selectedWeek;
                return ChoiceChip(
                  selected: selected,
                  label: Text('Week $w'),
                  onSelected: (_) => setState(() => _selectedWeek = w),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => JeffingTimerScreen(week: _selectedWeek),
                    ),
                  );
                },
                child: const Text('Start workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
