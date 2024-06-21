import 'dart:io';

import 'package:lua/domain/repositories/repositories.dart';

class LoadDirectoryContents {
  final FileRepository repository;

  LoadDirectoryContents(this.repository);

  Future<List<FileSystemEntity>> call(Directory directory) {
    return repository.listFilesAndDirectories(directory);
  }
}
