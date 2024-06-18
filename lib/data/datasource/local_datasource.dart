import 'package:lua/data/datasource/db/database_helper.dart';
import 'package:lua/domain/entities/entities.dart';

abstract class LocalDataSource {
  Future<void> insertSong(Song song);
  Future<void> deleteSong(int songId);
  Future<void> insertPlaylist(Playlist playlist);
  Future<List<Song>> getAllSongs();
  Future<List<Playlist>> getAllPlaylists();
  Future<void> updatePlaylist(Playlist playlist);
  Future<void> deletePlaylist(int playlistId);
}

class LocalDataSourceImpl implements LocalDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  Future<void> deletePlaylist(int playlistId) =>
      _databaseHelper.deletePlaylist(playlistId);

  @override
  Future<void> deleteSong(int songId) => _databaseHelper.deleteSong(songId);

  @override
  Future<List<Playlist>> getAllPlaylists() =>
      _databaseHelper.getAllPlaylists();

  @override
  Future<List<Song>> getAllSongs() => _databaseHelper.getAllSongs();

  @override
  Future<void> insertPlaylist(Playlist playlist) =>
      _databaseHelper.insertPlaylist(playlist);

  @override
  Future<void> insertSong(Song song) => _databaseHelper.insertSong(song);

  @override
  Future<void> updatePlaylist(Playlist playlist) =>
      _databaseHelper.updatePlaylist(playlist);
}
