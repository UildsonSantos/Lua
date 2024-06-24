import 'dart:io';

import 'package:equatable/equatable.dart';

class DirectoryContents extends Equatable {
  final List<Directory> directories;
  final List<File> files;
  final Map<Directory, int> folderCountMap;
  final Map<Directory, int> fileCountMap;

  const DirectoryContents(
    this.directories,
    this.files,
    this.folderCountMap,
    this.fileCountMap,
  );

  @override
  List<Object> get props => [directories, files, folderCountMap, fileCountMap];

  @override
  String toString() {
    return 'DirectoryContents(directories: $directories, files: $files, '
        'folderCountMap: $folderCountMap, fileCountMap: $fileCountMap)';
  }
}
