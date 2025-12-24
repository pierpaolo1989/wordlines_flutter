import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

enum GameEvent { correct, wrong, win }

class GameFeedback {
  final AudioPlayer _player = AudioPlayer();

  void trigger(GameEvent event) {
    switch (event) {
      case GameEvent.correct:
        _play("click.wav");
        HapticFeedback.lightImpact();
        break;
      case GameEvent.wrong:
        _play("wrong.wav");
        HapticFeedback.heavyImpact();
        break;
      case GameEvent.win:
        _play("win.wav");
        HapticFeedback.mediumImpact();
        break;
    }
  }

  void _play(String file) {
    _player.play(AssetSource('audio/$file'));
  }

  void dispose() {
    _player.dispose();
  }
}
