import 'package:lua/data/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'notes_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        artist TEXT,
        album TEXT,
        duration INTEGER,
        filePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE playlist_songs (
        playlistId INTEGER,
        songId INTEGER,
        FOREIGN KEY (playlistId) REFERENCES playlists(id) ON DELETE CASCADE,
        FOREIGN KEY (songId) REFERENCES songs(id) ON DELETE CASCADE,
        PRIMARY KEY (playlistId, songId)
      )
    ''');
  }

  Future<void> insertSong(SongModel song) async {
    final db = await database;
    await db.insert('songs', song.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteSong(int id) async {
    final db = await database;
    await db.delete('songs', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<SongModel>> getAllSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('songs');
    return List.generate(maps.length, (i) {
      return SongModel.fromMap(maps[i]);
    });
  }

  Future<List<PlaylistModel>> getAllPlaylists() async {
    final db = await database;
    final List<Map<String, dynamic>> playlistMaps = await db.query('playlists');

    List<PlaylistModel> playlists = [];

    for (Map<String, dynamic> playlistMap in playlistMaps) {
      List<Map<String, dynamic>> songMaps = await db.rawQuery('''
        SELECT s.*
        FROM songs s
        INNER JOIN playlist_songs ps ON s.id = ps.songId
        WHERE ps.playlistId = ?
      ''', [playlistMap['id']]);

      List<SongModel> songs =
          songMaps.map((songMap) => SongModel.fromMap(songMap)).toList();

      playlists.add(PlaylistModel(
        id: playlistMap['id'],
        name: playlistMap['name'],
        songs: songs,
      ));
    }

    return playlists;
  }

  Future<void> insertPlaylist(PlaylistModel playlist) async {
    final db = await database;
    int playlistId = await db.insert('playlists', playlist.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    // Converter a lista de Song para SongModel
    List<SongModel> songModels =
        playlist.songs.map((song) => SongModel.fromSong(song)).toList();

    for (SongModel song in songModels) {
      await db.insert(
          'playlist_songs', {'playlistId': playlistId, 'songId': song.id},
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> updatePlaylist(PlaylistModel playlist) async {
    final db = await database;
    await db.update('playlists', playlist.toMap(),
        where: 'id = ?', whereArgs: [playlist.id]);
    await db.delete('playlist_songs',
        where: 'playlistId = ?', whereArgs: [playlist.id]);

    // Converter a lista de Song para SongModel
    List<SongModel> songModels =
        playlist.songs.map((song) => SongModel.fromSong(song)).toList();

    for (SongModel song in songModels) {
      await db.insert(
          'playlist_songs', {'playlistId': playlist.id, 'songId': song.id},
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> deletePlaylist(int id) async {
    final db = await database;
    await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
    await db.delete('playlist_songs', where: 'playlistId = ?', whereArgs: [id]);
  }
}
