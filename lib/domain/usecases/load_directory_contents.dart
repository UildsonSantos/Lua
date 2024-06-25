import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class LoadDirectoryContents {
  final FileRepository repository;

  LoadDirectoryContents(this.repository);

  Future<Either<Failure, DirectoryContents>> call(
      DirectoryModel directory, int limit, int offset) async {
    return await repository.listFilesAndDirectories(directory,
        limit: limit, offset: offset);
  }
}
