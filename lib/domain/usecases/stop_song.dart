import 'package:lua/application/services/services.dart';

class StopSong {
  final MusicPlayerService playerService;

  StopSong(this.playerService);

  void call() {
    playerService.stop();
  }
}
