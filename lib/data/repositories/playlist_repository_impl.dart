import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/core/exceptions/exceptions.dart';
import 'package:lua/data/datasource/datasource.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final LocalDataSource localDataSource;

  PlaylistRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> createPlaylist(Playlist playlist) async {
    try {
      await localDataSource
          .insertPlaylist(PlaylistModel.fromPlaylist(playlist));
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure('Failed to create Playlist: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, List<Playlist>>> getAllPlaylists() async {
    try {
      final playlists = await localDataSource.getAllPlaylists();
      return Right(playlists
          .map((playlistModel) => playlistModel.toPlaylist())
          .toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure('Failed to get all Playlists: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, void>> removePlaylist(int id) async {
    try {
      await localDataSource.deletePlaylist(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure('Failed to remove Playlist: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePlaylist(Playlist playlist) async {
    try {
      await localDataSource
          .updatePlaylist(PlaylistModel.fromPlaylist(playlist));
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure('Failed to update Playlist: ${e.message}'));
    }
  }
}
