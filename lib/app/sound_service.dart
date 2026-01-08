import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  final AudioPlayer _player = AudioPlayer();
  bool _ready = false;
  bool _isBeeping = false;

  Future<void> init() async {
    if (_ready) return;

    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.setVolume(1.0);

    // Precarga para macOS: evita estados raros del channel
    await _player.setSource(AssetSource('sounds/beep.mp3'));

    _ready = true;
  }

  Future<void> beep() async {
    if (_isBeeping) return;
    _isBeeping = true;

    try {
      if (!_ready) {
        await init();
      }
      // Más estable que stop()+play en macOS
      await _player.seek(Duration.zero);
      await _player.resume();
    } catch (_) {
      // no romper la app si falla el audio
    } finally {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      _isBeeping = false;
    }
  }
}
