import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

abstract class PlaylistService {
  Future<void> addSongToPlaylist(Playlist playlist, Song song);
  Future<void> removeSongFromPlaylist(Playlist playlist, Song song);
  Future<void> renamePlaylist(Playlist playlist, String newName);
  Future<void> reorderPlaylist(Playlist playlist, int oldIndex, int newIndex);
}

class PlaylistServiceImpl implements PlaylistService {
  final PlaylistRepository _repository;

  PlaylistServiceImpl(this._repository);

  @override
  Future<void> addSongToPlaylist(Playlist playlist, Song song) async {
    final List<Song> updatedSongs = List.from(playlist.songs);
    updatedSongs.add(song);
    final updatedPlaylist = playlist.copyWith(songs: updatedSongs);
    await _repository.updatePlaylist(updatedPlaylist);
  }

  @override
  Future<void> removeSongFromPlaylist(Playlist playlist, Song song) async {
    final List<Song> updatedSongs =
        playlist.songs.where((s) => s.id != song.id).toList();

    final updatedPlaylist = playlist.copyWith(songs: updatedSongs);
    await _repository.updatePlaylist(updatedPlaylist);
  }

  @override
  Future<void> renamePlaylist(Playlist playlist, String newName) async {
    final updatedPlaylist = playlist.copyWith(name: newName);
    await _repository.updatePlaylist(updatedPlaylist);
  }

  @override
  Future<void> reorderPlaylist(
      Playlist playlist, int oldIndex, int newIndex) async {
    final List<Song> songs = List.from(playlist.songs);
    final Song song = songs.removeAt(oldIndex);
    songs.insert(newIndex, song);

    // Ordena a lista de músicas com base na duração
    songs.sort((a, b) => a.duration.compareTo(b.duration));

    final updatedPlaylist = playlist.copyWith(songs: songs);
    await _repository.updatePlaylist(updatedPlaylist);
  }
}
