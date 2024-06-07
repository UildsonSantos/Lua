import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class GetAllPlaylists {
  final PlaylistRepository repository;

  GetAllPlaylists(this.repository);

  Future<Either<Failure, List<Playlist>>> call() async {
    return await repository.getAllPlaylists();
  }
}
