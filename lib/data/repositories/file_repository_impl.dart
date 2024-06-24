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
    Map<Directory, int> folderCountMap = {};
    Map<Directory, int> fileCountMap = {};

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

     
      for (var dir in directories) {
        var contents = await listFilesAndDirectories(dir);
        folderCountMap[dir] = contents.folderCount;
        fileCountMap[dir] = contents.fileCount;
      }
    }

    return DirectoryContents(
      directories: directories,
      files: files,
      folderCountMap: folderCountMap.isNotEmpty ? folderCountMap : null,
      fileCountMap: fileCountMap.isNotEmpty ? fileCountMap : null,
    );
  }

  @override
  Future<bool> requestPermission() {
    return musicFileDataSource.requestPermission();
  }
}
