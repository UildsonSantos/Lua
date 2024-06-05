import 'package:just_audio/just_audio.dart';
import 'package:lua/domain/entities/entities.dart';

class MusicPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> play(Song song) async {
    try {
      await _audioPlayer.setFilePath(song.filePath);
      _audioPlayer.play();
    } catch (e) {
      // Handle error
      print('Error playing song: $e');
    }
  }

  void pause() {
    _audioPlayer.pause();
  }

  void stop() {
    _audioPlayer.stop();
  }
}