import 'package:lua/shared/data/database/database.dart';

class FileDAO {
  final FileDatabase _database = FileDatabase.instance;

  Future<void> clearDatabase() async {
    final db = await _database.database;
    await db.delete('directories');
  }

  Future<int> insertFileOrDirectory(Map<String, dynamic> directory) async {
    final db = await _database.database;
    return await db.insert('directories', directory);
  }

  Future<void> updateParentId(int id, int parentId) async {
    final db = await _database.database;
    await db.update(
      'directories',
      {'parent_id': parentId},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, List<dynamic>>> getFileOrDirectoryContents(
      String parentId) async {
    final db = await _database.database;

    final List<Map<String, dynamic>> directories = await db.query(
      'directories',
      where: 'parent_id = ?',
      whereArgs: [parentId],
    );

    List<Map<String, dynamic>> subDirectories =
        directories.where((dir) => dir['type'] == 'dir').map((dir) {
      return {
        'id': dir['id'],
        'path': dir['path'],
        'type': dir['type'],
        'parentId': dir['parent_id'],
        'isFavorite': dir['isFavorite'] == 1 ? true : false,
        'name': dir['name'],
      };
    }).toList();

    List<Map<String, dynamic>> mediaFiles =
        directories.where((dir) => dir['type'] == 'file').toList();

    // Compute fileCount and folderCount for each subDirectory
    for (var subDir in subDirectories) {
      subDir['fileCount'] = await _getFileCount(subDir['path']);
      subDir['folderCount'] = await _getFolderCount(subDir['path']);
    }

    return {'directories': subDirectories, 'files': mediaFiles};
  }

  Future<int> _getFileCount(String dirPath) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result = await db.query(
      'directories',
      where: 'parent_id = ? AND type = ?',
      whereArgs: [dirPath, 'file'],
    );
    return result.length;
  }

  Future<int> _getFolderCount(String dirPath) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result = await db.query(
      'directories',
      where: 'parent_id = ? AND type = ?',
      whereArgs: [dirPath, 'dir'],
    );
    return result.length;
  }
}
