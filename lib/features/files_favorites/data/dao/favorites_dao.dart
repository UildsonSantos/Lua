import 'package:lua/shared/data/database/database.dart';
import 'package:lua/shared/data/models/models.dart';

class FavoritesDAO {
  final FileDatabase _database = FileDatabase.instance;

  Future<List<DirectoryInfo>> getFavoriteDirectories() async {
    final db = await _database.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'directories',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );

    List<DirectoryInfo> directories = [];

    for (var map in maps) {
      String path = map['path'];

      final List<Map<String, dynamic>> counts = await db.rawQuery('''
      SELECT 
        SUM(CASE WHEN type = 'dir' THEN 1 ELSE 0 END) AS folderCount,
        SUM(CASE WHEN type = 'file' THEN 1 ELSE 0 END) AS fileCount
      FROM directories
      WHERE parent_id = ?
    ''', [path]);

      int folderCount = counts[0]['folderCount'] ?? 0;
      int fileCount = counts[0]['fileCount'] ?? 0;

      directories.add(DirectoryInfo(
        id: map['id'],
        path: map['path'],
        name: map['name'],
        isFavorite: map['isFavorite'] == 1,
        type: map['type'],
        parentId: map['parent_id'],
        fileCount: fileCount,
        folderCount: folderCount,
      ));
    }

    return directories;
  }

  Future<void> addToFavorites(String path) async {
    final db = await _database.database;
    await db.update(
      'directories',
      {'isFavorite': 1},
      where: 'path = ?',
      whereArgs: [path],
    );
  }

  Future<void> removeFromFavorites(String path) async {
    final db = await _database.database;
    await db.update(
      'directories',
      {'isFavorite': 0},
      where: 'path = ?',
      whereArgs: [path],
    );
  }
}
