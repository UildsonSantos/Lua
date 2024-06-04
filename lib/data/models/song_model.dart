import 'package:lua/domain/entities/entities.dart';

class SongModel extends Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final int duration; // Duration in seconds
  final String filePath;

  const SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.filePath,
  }) : super(
            id: '',
            title: '',
            artist: '',
            album: '',
            duration: 0,
            filePath: '');
}
