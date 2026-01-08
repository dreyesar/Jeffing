import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/sound_cues_controller.dart';
import '../../../app/theme_mode_controller.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeControllerProvider);
    final themeController = ref.read(themeModeControllerProvider.notifier);

    final soundAsync = ref.watch(soundCuesControllerProvider);
    final soundController = ref.read(soundCuesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          themeModeAsync.when(
            loading: () => const _CardLoading(title: 'Theme'),
            error: (e, _) => _CardError(title: 'Theme', message: e.toString()),
            data: (mode) => Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _Header(title: 'Theme'),
                    const SizedBox(height: 6),
                    _RadioTile(
                      title: 'System',
                      subtitle: 'Match your device setting',
                      value: ThemeMode.system,
                      groupValue: mode,
                      onChanged: themeController.setThemeMode,
                    ),
                    const Divider(height: 1),
                    _RadioTile(
                      title: 'Light',
                      subtitle: 'Always light',
                      value: ThemeMode.light,
                      groupValue: mode,
                      onChanged: themeController.setThemeMode,
                    ),
                    const Divider(height: 1),
                    _RadioTile(
                      title: 'Dark',
                      subtitle: 'Always dark',
                      value: ThemeMode.dark,
                      groupValue: mode,
                      onChanged: themeController.setThemeMode,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          soundAsync.when(
            loading: () => const _CardLoading(title: 'Sound'),
            error: (e, _) => _CardError(title: 'Sound', message: e.toString()),
            data: (enabled) => Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _Header(title: 'Sound'),
                    const SizedBox(height: 6),
                    SwitchListTile.adaptive(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: const Text(
                        'Sound cues',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text('Beep on phase change'),
                      value: enabled,
                      onChanged: soundController.setEnabled,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on bool {
  when({required _CardLoading Function() loading, required _CardError Function(dynamic e, dynamic _) error, required Card Function(dynamic enabled) data}) {}
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode> onChanged;

  const _RadioTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ThemeMode>(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      value: value,
      groupValue: groupValue,
      onChanged: (v) => v == null ? null : onChanged(v),
    );
  }
}

class _CardLoading extends StatelessWidget {
  final String title;
  const _CardLoading({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(width: 12),
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardError extends StatelessWidget {
  final String title;
  final String message;
  const _CardError({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('$title error: $message'),
      ),
    );
  }
}
