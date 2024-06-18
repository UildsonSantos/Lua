import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:lua/domain/entities/entities.dart';

class MusicFileDataSource {
  Future<List<Song>> getLocalSongs() async {
    final directory = Directory('/storage/emulated/0');
    if (directory.existsSync()) {
      final musicFiles = directory
          .listSync()
          .where((file) =>
              (file.path.endsWith('.mp3') || (file.path.endsWith('.mp4'))))
          .toList();

      List<Song> songs = [];

      for (var file in musicFiles) {
        final metadata = await MetadataRetriever.fromFile(File(file.path));

        songs.add(Song(
          id: file.path,
          title: metadata.trackName ?? file.uri.pathSegments.last,
          artist: metadata.trackArtistNames?.join(', ') ?? 'Unknown Artist',
          album: metadata.albumName ?? 'Unknown Album',
          duration: metadata.trackDuration ?? 0,
          filePath: file.path,
        ));
      }

      return songs;
    } else {
      throw Exception('Directory not found');
    }
  }

  Future<Song> getSingleLocalSong(String source) async {
    File file = File(source);
    final metadata = await MetadataRetriever.fromFile(File(file.path));

    Song singleSong = Song(
      id: source,
      title: metadata.trackName ?? file.uri.pathSegments.last,
      artist: metadata.trackArtistNames?.join(', ') ?? 'Unknown Artist',
      album: metadata.albumName ?? 'Unknown Album',
      duration: metadata.trackDuration ?? 0,
      filePath: file.path,
    );
    return singleSong;
  }
}
