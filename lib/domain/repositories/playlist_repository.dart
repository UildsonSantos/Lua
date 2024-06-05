import 'package:lua/domain/entities/entities.dart';

abstract class PlaylistRepository {
  Future<void> createPlaylist(Playlist playlist);
  Future<List<Playlist>> getAllPlaylists();
  Future<void> removePlaylist(int id);
  Future<void> updatePlaylist(Playlist playlist);
}
