import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class CreatePlaylist {
  final PlaylistRepository repository;

  CreatePlaylist(this.repository);

  Future<Either<Failure, void>> call(Playlist playlist) async {
    return await repository.createPlaylist(playlist);
  }
}
