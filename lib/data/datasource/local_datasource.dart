import 'package:lua/data/datasource/db/database_helper.dart';
import 'package:lua/data/models/models.dart';

abstract class LocalDataSource {
  Future<void> insertSong(SongModel song);
  Future<void> deleteSong(int songId);
  Future<void> insertPlaylist(PlaylistModel playlist);
  Future<List<SongModel>> getAllSongs();
  Future<List<PlaylistModel>> getAllPlaylists();
  Future<void> updatePlaylist(PlaylistModel playlist);
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
  Future<List<PlaylistModel>> getAllPlaylists() =>
      _databaseHelper.getAllPlaylists();

  @override
  Future<List<SongModel>> getAllSongs() => _databaseHelper.getAllSongs();

  @override
  Future<void> insertPlaylist(PlaylistModel playlist) =>
      _databaseHelper.insertPlaylist(playlist);

  @override
  Future<void> insertSong(SongModel song) => _databaseHelper.insertSong(song);

  @override
  Future<void> updatePlaylist(PlaylistModel playlist) =>
      _databaseHelper.updatePlaylist(playlist);
}
