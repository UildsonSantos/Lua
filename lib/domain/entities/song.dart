import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final int? id;
  final String title;
  final String artist;
  final String album;
  final int duration;
  final String filePath;

  const Song({
    this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.filePath,
  });

  @override
  List<Object> get props {
    return [
      id!,
      title,
      artist,
      album,
      duration,
      filePath,
    ];
  }
}
