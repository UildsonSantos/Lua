import 'package:lua/data/datasource/db/database_helper.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/domain/entities/entities.dart';

abstract class LocalDataSource {
  Future<void> insertSong(Song song);
  Future<void> deleteSong(int songId);
  Future<void> insertPlaylist(Playlist playlist);
  Future<List<Song>> getAllSongs();
  Future<List<Playlist>> getAllPlaylists();
  Future<void> updatePlaylist(Playlist playlist);
  Future<void> deletePlaylist(int playlistId);
  Future<void> insertDirectory(DirectoryModel directory);
  Future<void> insertFile(FileModel file);
  Future<List<DirectoryModel>> getAllDirectories(
      {int limit = 10, int offset = 0});
  Future<List<FileModel>> getAllFilesByDirectoryId(int directoryId,
      {int limit = 10, int offset = 0});
  Future<DirectoryModel?> getDirectoryByPath(String path);
}

class LocalDataSourceImpl implements LocalDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  Future<void> deletePlaylist(int playlistId) =>
      _databaseHelper.deletePlaylist(playlistId);

  @override
  Future<void> deleteSong(int songId) => _databaseHelper.deleteSong(songId);

  @override
  Future<List<Playlist>> getAllPlaylists() => _databaseHelper.getAllPlaylists();

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

  @override
  Future<List<DirectoryModel>> getAllDirectories(
          {int limit = 10, int offset = 0}) =>
      _databaseHelper.getAllDirectories(limit: limit, offset: offset);
  @override
  Future<List<FileModel>> getAllFilesByDirectoryId(int directoryId,
          {int limit = 10, int offset = 0}) =>
      _databaseHelper.getAllFilesByDirectoryId(directoryId,
          limit: limit, offset: offset);

  @override
  Future<void> insertDirectory(DirectoryModel directory) =>
      _databaseHelper.insertDirectoryModel(directory);

  @override
  Future<void> insertFile(FileModel file) =>
      _databaseHelper.insertFileModel(file);

  @override
  Future<DirectoryModel?> getDirectoryByPath(String path) =>
      _databaseHelper.getDirectoryByPath(path);
}
