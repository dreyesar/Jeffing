import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoundSettingsController extends Notifier<bool> {
  @override
  bool build() => true; // sound ON by default

  void toggle() => state = !state;

  void setEnabled(bool v) => state = v;
}

final soundSettingsProvider =
    NotifierProvider<SoundSettingsController, bool>(SoundSettingsController.new);
