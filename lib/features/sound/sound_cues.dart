import 'package:audioplayers/audioplayers.dart';

class SoundCues {
  final AudioPlayer _player = AudioPlayer();

  SoundCues() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> beep() async {
    await _player.stop();
    await _player.play(AssetSource('assets/sounds/beep.mp3'));
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
