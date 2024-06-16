import 'dart:io';

import 'package:lua/domain/repositories/repositories.dart';

class FileRepositoryImpl implements FileRepository {
  @override
  Future<List<FileSystemEntity>> listFilesAndDirectories(
      Directory directory) async {
    List<FileSystemEntity> entities = [];
    if (directory.existsSync()) {
      await for (FileSystemEntity entity in directory.list()) {
        entities.add(entity);
      }
    }
    return entities;
  }
}
