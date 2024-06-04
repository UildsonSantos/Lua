import 'package:lua/domain/entities/entities.dart';

abstract class PlaylistRepository {
  Future<void> createPlaylist(Playlist playlist);
}
