import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lua/domain/entities/entities.dart';

class MusicPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  static final MusicPlayerService _instance = MusicPlayerService._internal();

  factory MusicPlayerService() {
    return _instance;
  }

  MusicPlayerService._internal();

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> play(Song song) async {
    try {
      await _audioPlayer.setFilePath(song.filePath);
      _audioPlayer.play();
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error playing song: $e');
      }
    }
  }

  void pause() {
    _audioPlayer.pause();
  }

  void stop() {
    _audioPlayer.stop();
  }
}
