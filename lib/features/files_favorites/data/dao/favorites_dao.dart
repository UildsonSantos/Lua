import 'package:lua/shared/data/database/database.dart';
import 'package:lua/shared/data/models/models.dart';

class FavoritesDAO {
  Future<List<DirectoryInfo>> getFavoriteDirectories() async {
    final db = await FileDatabase.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('files', where: 'isFavorite = 1');

    return List.generate(maps.length, (i) {
      return DirectoryInfo(
        path: maps[i]['path'],
        fileCount: maps[i]['fileCount'],
        folderCount: maps[i]['folderCount'],
        isFavorite: maps[i]['isFavorite'] == 1,
        name: maps[i]['name'],
      );
    });
  }

  Future<void> addToFavorites(String path) async {
    final db = await FileDatabase.instance.database;
    await db.update('files', {'isFavorite': 1},
        where: 'path = ?', whereArgs: [path]);
  }

  Future<void> removeFromFavorites(String path) async {
    final db = await FileDatabase.instance.database;
    await db.update('files', {'isFavorite': 0},
        where: 'path = ?', whereArgs: [path]);
  }
}
