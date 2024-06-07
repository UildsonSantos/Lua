import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/domain/repositories/playlist_repository.dart';

class RemovePlaylist {
  final PlaylistRepository repository;

  RemovePlaylist(this.repository);

  Future<Either<Failure, void>> call(int playlistId) async {
    return await repository.removePlaylist(playlistId);
  }
}
