import 'dart:io';

import 'package:lua/data/sources/souces.dart';
import 'package:lua/domain/entities/directory_contents.dart';
import 'package:lua/domain/repositories/repositories.dart';

class FileRepositoryImpl implements FileRepository {
  final MusicFileDataSource musicFileDataSource;

  FileRepositoryImpl(this.musicFileDataSource);

  @override
  Future<List<FileSystemEntity>> listAllFileSystem(Directory directory) async {
    List<FileSystemEntity> entities = [];
    if (directory.existsSync()) {
      await for (FileSystemEntity entity in directory.list()) {
        entities.add(entity);
      }
    }
    return entities;
  }

  @override
  Future<DirectoryContents> listFilesAndDirectories(Directory directory) async {
    List<Directory> directories = [];
    List<File> files = [];

    if (directory.existsSync()) {
      await for (FileSystemEntity entity in directory.list()) {
        if (entity is Directory &&
            !entity.path.split('/').last.startsWith('.') &&
            !entity.path.contains('/Android/')) {
          directories.add(entity);
        } else if (entity is File) {
          files.add(entity);
        }
      }
    }

    return DirectoryContents(directories, files);
  }

  @override
  Future<bool> requestPermission() {
    return musicFileDataSource.requestPermission();
  }
}
