import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/domain/entities/entities.dart';

abstract class SongRepository {
  Future<Either<Failure, List<Song>>> getAllSongs();
}
