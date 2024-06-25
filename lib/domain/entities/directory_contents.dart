import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:lua/data/models/models.dart';

class DirectoryContents extends Equatable {
  final List<DirectoryModel> directories;
  final List<FileModel> files;

  final Map<Directory, int>? folderCountMap;
  final Map<Directory, int>? fileCountMap;

  const DirectoryContents({
    required this.directories,
    required this.files,
    this.folderCountMap,
    this.fileCountMap,
  });

  int get folderCount => directories.length;
  int get fileCount => files.length;

  int getFolderCountForDirectory(Directory directory) {
    return folderCountMap?[directory] ?? 0;
  }

  int getFileCountForDirectory(Directory directory) {
    return fileCountMap?[directory] ?? 0;
  }

  @override
  List<Object?> get props => [directories, files, folderCountMap, fileCountMap];

  @override
  String toString() {
    return 'DirectoryContents(directories: $directories, files: $files, '
        'folderCountMap: $folderCountMap, fileCountMap: $fileCountMap)';
  }
}
