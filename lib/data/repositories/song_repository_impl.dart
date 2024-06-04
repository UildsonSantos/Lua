import 'package:lua/data/sources/souces.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class SongRepositoryImpl implements SongRepository {
  final MusicFileDataSource musicFileDataSource;

  SongRepositoryImpl(this.musicFileDataSource);

  @override
  Future<List<Song>> getAllSongs() async {
    final songModels = await musicFileDataSource.getLocalSongs();
    return songModels
        .map((model) => Song(
              id: model.id,
              title: model.title,
              artist: model.artist,
              album: model.album,
              duration: model.duration,
              filePath: model.filePath,
            ))
        .toList();
  }
}
