import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'package:lua/data/models/models.dart';
import 'package:lua/data/sources/souces.dart';
import 'package:lua/domain/repositories/repositories.dart';

class FileRepositoryImpl implements FileRepository {
  final MusicFileDataSource musicFileDataSource;

  FileRepositoryImpl(this.musicFileDataSource);

  bool isAndroidDataDirectory(Directory directory) {
    return directory.path.contains('/Android/');
  }

  bool isMediaFile(File file) {
    String extension = p.extension(file.path).toLowerCase();
    return extension == '.mp3' || extension == '.mp4';
  }

  @override
  Future<Map<String, int>> countFilesAndDirectories(Directory directory) async {
    int fileCount = 0;
    int dirCount = 0;

    await for (var entity
        in directory.list(recursive: false, followLinks: false)) {
      if (entity is Directory &&
          !entity.path.split('/').last.startsWith('.') &&
          isAndroidDataDirectory(entity)) {
        continue;
      }

      if (entity is File) {
        fileCount++;
      } else if (entity is Directory) {
        dirCount++;
      }
    }

    return {'files': fileCount, 'directories': dirCount};
  }

  @override
  Future<Map<String, List<dynamic>>> listDirectoriesAndFiles(
      String dirPath) async {
    var mainDirectory = Directory(dirPath);
    List<DirectoryInfo> subDirectories = [];
    List<File> mediaFiles = [];

    if (!(await mainDirectory.exists())) {
      if (kDebugMode) {
        print('O diretório não existe.');
      }
      return {'directories': subDirectories, 'files': mediaFiles};
    }

    await for (var entity
        in mainDirectory.list(recursive: false, followLinks: false)) {
      if (entity is Directory && !isAndroidDataDirectory(entity)) {
        var result = await countFilesAndDirectories(entity);
        DirectoryInfo info = DirectoryInfo(
          path: entity.path,
          fileCount: result['files']!,
          folderCount: result['directories']!,
        );
        subDirectories.add(info);
      } else if (entity is File && isMediaFile(entity)) {
        mediaFiles.add(entity);
      }
    }

    return {'directories': subDirectories, 'files': mediaFiles};
  }

  @override
  Future<bool> requestPermission() {
    return musicFileDataSource.requestPermission();
  }
}
