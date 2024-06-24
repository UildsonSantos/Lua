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
      } else if (entity is File &&
          (entity.path.endsWith('.mp3') || entity.path.endsWith('.mp4'))) {
        files.add(entity);
      }
    }
  }

  // Ordenando diretórios e arquivos
  directories.sort((a, b) => a.path.compareTo(b.path));
  files.sort((a, b) => a.path.compareTo(b.path));

  int folderCount = directories.length;
  int fileCount = files.length;

  return DirectoryContents(directories, files, folderCount, fileCount);
}


  @override
  Future<bool> requestPermission() {
    return musicFileDataSource.requestPermission();
  }
}
