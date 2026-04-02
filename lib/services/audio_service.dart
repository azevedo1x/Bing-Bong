import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../core/constants/audio_constants.dart';
import 'audio_randomizer.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final AudioRandomizer _randomizer = AudioRandomizer(kAudioFiles);
  StreamSubscription<void>? _completeSub;
  bool _isPlaying = false;

  void onComplete(void Function() callback) {
    _completeSub?.cancel();
    _completeSub = _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
      callback();
    });
  }

  /// Toca a próxima voice line e retorna a frase extraída do nome do arquivo.
  Future<String> playNext() async {
    if (_isPlaying) {
      await _player.stop();
    }
    final path = _randomizer.next();
    await _player.play(AssetSource(path));
    _isPlaying = true;
    return _extractQuote(path);
  }

  /// Extrai a frase do nome do arquivo: "audio/im bing bong.mp3" → "im bing bong"
  String _extractQuote(String path) {
    return path
        .split('/')
        .last
        .replaceAll('.mp3', '')
        .replaceAll('_', "'");
  }

  Future<void> dispose() async {
    _completeSub?.cancel();
    _completeSub = null;
    await _player.dispose();
  }
}
