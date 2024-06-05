import 'package:lua/data/models/models.dart';
import 'package:lua/domain/repositories/repositories.dart';

abstract class PlaylistService {
  Future<void> addSongToPlaylist(PlaylistModel playlist, SongModel song);
  Future<void> removeSongFromPlaylist(PlaylistModel playlist, SongModel song);
  Future<void> renamePlaylist(PlaylistModel playlist, String newName);
  Future<void> reorderPlaylist(
      PlaylistModel playlist, int oldIndex, int newIndex);
}

class PlaylistServiceImpl implements PlaylistService {
  final PlaylistRepository _repository;

  PlaylistServiceImpl(this._repository);

  @override
  Future<void> addSongToPlaylist(PlaylistModel playlist, SongModel song) async {
    final List<SongModel> updatedSongs =
        playlist.songs.map((song) => SongModel.fromSong(song)).toList();
    updatedSongs.add(song);
    final updatedPlaylist = playlist.copyWith(songs: updatedSongs);
    await _repository.updatePlaylist(updatedPlaylist);
  }

  @override
  Future<void> removeSongFromPlaylist(
      PlaylistModel playlist, SongModel song) async {
    final List<SongModel> updatedSongs = playlist.songs
        .where((s) => s.id != song.id)
        .map((song) => SongModel.fromSong(song))
        .toList();
    final updatedPlaylist = playlist.copyWith(songs: updatedSongs);
    await _repository.updatePlaylist(updatedPlaylist);
  }

  @override
  Future<void> renamePlaylist(PlaylistModel playlist, String newName) async {
    final updatedPlaylist = playlist.copyWith(name: newName);
    await _repository.updatePlaylist(updatedPlaylist);
  }

  @override
  Future<void> reorderPlaylist(
      PlaylistModel playlist, int oldIndex, int newIndex) async {
    final List<SongModel> songs =
        List.from(playlist.songs.map((song) => SongModel.fromSong(song)));
    final SongModel song = songs.removeAt(oldIndex);
    songs.insert(newIndex, song);

    // Ordena a lista de músicas com base na duração
    songs.sort((a, b) => a.duration.compareTo(b.duration));

    final updatedPlaylist =
        playlist.copyWith(songs: songs.map((songModel) => songModel).toList());
    await _repository.updatePlaylist(updatedPlaylist);
  }
}
