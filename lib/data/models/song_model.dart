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

  factory SongModel.fromSong(Song song) {
    return SongModel(
      id: song.id,
      title: song.title,
      artist: song.artist,
      album: song.album,
      duration: song.duration,
      filePath: song.filePath,
    );
  }

  Song toSong() {
    return Song(
      id: id,
      title: title,
      artist: artist,
      album: album,
      duration: duration,
      filePath: filePath,
    );
  }
}
