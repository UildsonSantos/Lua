import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/domain/entities/entities.dart';

abstract class FileRepository {
  Future<List<FileSystemEntity>> listAllFileSystem(Directory directory);
  Future<Either<Failure, DirectoryContents>> listFilesAndDirectories(
      DirectoryModel directory,
      {int limit = 10,
      int offset = 0});
  Future<bool> requestPermission();
}
