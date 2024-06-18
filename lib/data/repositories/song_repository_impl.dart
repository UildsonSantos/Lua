import 'package:dartz/dartz.dart';
import 'package:lua/core/error/error.dart';
import 'package:lua/data/datasource/datasource.dart';
import 'package:lua/data/sources/souces.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class SongRepositoryImpl implements SongRepository {
  final LocalDataSource localDataSource;
  final MusicFileDataSource musicFileDataSource;

  SongRepositoryImpl(this.localDataSource, this.musicFileDataSource);

  @override
  Future<Either<Failure, List<Song>>> getAllSongs() async {
    try {
      // Primeiro, tenta obter as músicas do banco de dados local
      final localSongs = await localDataSource.getAllSongs();
      if (localSongs.isNotEmpty) {
        return Right(localSongs);
      }

      // Se não houver músicas no banco de dados local, tenta obter do sistema de arquivos
      final fileSongs = await musicFileDataSource.getLocalSongs();
      return Right(fileSongs);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get local songs: $e'));
    }
  }
}
