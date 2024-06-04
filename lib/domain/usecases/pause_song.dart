import 'package:lua/application/services/services.dart';

class PauseSong {
  final MusicPlayerService playerService;

  PauseSong(this.playerService);

  void call() {
    playerService.pause();
  }
}
