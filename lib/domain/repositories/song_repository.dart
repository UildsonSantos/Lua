import 'package:lua/domain/entities/entities.dart';

abstract class SongRepository {
  Future<List<Song>> getAllSongs();
}
