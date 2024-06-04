import 'package:lua/application/services/services.dart';
import 'package:lua/domain/entities/entities.dart';

class PlaySong {
  final MusicPlayerService playerService;

  PlaySong(this.playerService);

  void call(Song song) {
    playerService.play(song);
  }
}
