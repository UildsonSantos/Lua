import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final List<Playlist> _playlists = [];

  @override
  Future<void> createPlaylist(Playlist playlist) async {
    _playlists.add(playlist);
  }

  @override
  Future<List<Playlist>> getAllPlaylists() async {
    return _playlists;
  }

  @override
  Future<void> removePlaylist(int id) async {
    _playlists.removeWhere((playlist) => playlist.id == id);
  }
}
