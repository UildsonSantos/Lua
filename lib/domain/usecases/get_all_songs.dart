import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class GetAllSongs {
  final SongRepository repository;

  GetAllSongs(this.repository);

  Future<Either<Failure, List<Song>>> call() async {
    return await repository.getAllSongs();
  }
}
