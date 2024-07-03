
import 'package:lua/shared/data/database/database.dart';
import 'package:lua/shared/data/models/models.dart';

class FileDAO {
  Future<List<DirectoryInfo>> getAllDirectories() async {
    final db = await FileDatabase.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('files');

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

  Future<void> saveDirectories(List<DirectoryInfo> directories) async {
    final db = await FileDatabase.instance.database;

    for (final directory in directories) {
      await db.insert('files', {
        'path': directory.path,
        'fileCount': directory.fileCount,
        'folderCount': directory.folderCount,
        'isFavorite': directory.isFavorite ? 1 : 0,
        'name': directory.name,
      });
    }
  }
}