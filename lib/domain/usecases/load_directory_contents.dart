import 'dart:io';

import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class LoadDirectoryContents {
  final FileRepository repository;

  LoadDirectoryContents(this.repository);

  Future<DirectoryContents> call(Directory directory) {
    return repository.listFilesAndDirectories(directory);
  }
}
