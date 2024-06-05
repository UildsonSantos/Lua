import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:lua/data/models/models.dart';
import 'package:path_provider/path_provider.dart';

class MusicFileDataSource {
  Future<List<SongModel>> getLocalSongs() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final musicFiles = directory
          .listSync()
          .where((file) => file.path.endsWith('.mp3'))
          .toList();

      List<SongModel> songs = [];

      for (var file in musicFiles) {
        final metadata = await MetadataRetriever.fromFile(File(file.path));

        songs.add(SongModel(
          id: null, // ID será gerado pelo banco de dados
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
}
