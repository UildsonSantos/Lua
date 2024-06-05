import 'package:lua/data/models/models.dart';

abstract class PlaylistService {
  Future<void> addSongToPlaylist(PlaylistModel playlist, SongModel song);
  Future<void> removeSongFromPlaylist(PlaylistModel playlist, SongModel song);
  Future<void> renamePlaylist(PlaylistModel playlist, String newName);
  Future<void> reorderPlaylist(
      PlaylistModel playlist, int oldIndex, int newIndex);
}
