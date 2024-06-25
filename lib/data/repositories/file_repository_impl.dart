import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/data/datasource/datasource.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/data/sources/souces.dart';
import 'package:lua/domain/entities/directory_contents.dart';
import 'package:lua/domain/repositories/repositories.dart';

class FileRepositoryImpl implements FileRepository {
  final MusicFileDataSource musicFileDataSource;
  final LocalDataSource localDataSource;

  FileRepositoryImpl(this.musicFileDataSource, this.localDataSource);

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
  Future<Either<Failure, DirectoryContents>> listFilesAndDirectories(
      DirectoryModel directory,
      {int limit = 10,
      int offset = 0}) async {
    try {
      final directories =
          await localDataSource.getAllDirectories(limit: limit, offset: offset);
      final files = await localDataSource.getAllFilesByDirectoryId(
          directory.id!,
          limit: limit,
          offset: offset);
      return Right(DirectoryContents(directories: directories, files: files));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<bool> requestPermission() {
    return musicFileDataSource.requestPermission();
  }
}
