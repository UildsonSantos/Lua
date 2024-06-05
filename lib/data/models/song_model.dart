import 'package:lua/domain/entities/entities.dart';

class SongModel extends Song {
  const SongModel({
    super.id,
    required super.title,
    required super.artist,
    required super.album,
    required super.duration,
    required super.filePath,
  });
}
