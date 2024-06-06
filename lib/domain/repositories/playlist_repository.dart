import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/domain/entities/entities.dart';

abstract class PlaylistRepository {
  Future<Either<Failure, void>> createPlaylist(Playlist playlist);
  Future<Either<Failure, List<Playlist>>> getAllPlaylists();
  Future<Either<Failure, void>> removePlaylist(int id);
  Future<Either<Failure, void>> updatePlaylist(Playlist playlist);
}
