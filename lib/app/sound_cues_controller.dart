import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final soundCuesControllerProvider =
    NotifierProvider<SoundCuesController, bool>(SoundCuesController.new);

class SoundCuesController extends Notifier<bool> {
  @override
  bool build() => true; // default: ON

  void toggle() => state = !state;
  void setEnabled(bool enabled) => state = enabled;
}

final _beepPlayerProvider = Provider.autoDispose<AudioPlayer>((ref) {
  final p = AudioPlayer();
  ref.onDispose(() async {
    try {
      await p.stop();
    } catch (_) {}
    await p.dispose();
  });
  return p;
});

/// Reproduce el beep si está habilitado.
/// Importante: el path debe coincidir con pubspec.yaml.
/// En tu pubspec tenés: - assets/sounds/beep.mp3
Future<void> playBeep(WidgetRef ref) async {
  final enabled = ref.read(soundCuesControllerProvider);
  if (!enabled) return;

  final player = ref.read(_beepPlayerProvider);

  try {
    // evita errores raros por play repetido muy seguido
    await player.stop();
    await player.play(AssetSource('assets/sounds/beep.mp3'));
  } catch (_) {
    // si falla, no tiramos abajo la app (solo ignoramos)
  }
}
