import 'dart:io';

import 'package:lua/data/sources/souces.dart';
import 'package:lua/domain/repositories/repositories.dart';

class FileRepositoryImpl implements FileRepository {
  final MusicFileDataSource musicFileDataSource;

  FileRepositoryImpl(this.musicFileDataSource);
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

  @override
  Future<bool> requestPermission() {
    return musicFileDataSource.requestPermission();
  }
}
