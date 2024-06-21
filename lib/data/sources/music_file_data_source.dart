import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<List<FileSystemEntity>> listFilesAndDirectories(
      Directory directory) async {
    return directory.list().toList();
  }

  Future<bool> requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> status = await [
        Permission.audio,
        Permission.videos,
        Permission.photos,
        Permission.manageExternalStorage,
      ].request();

      return (status[Permission.audio]!.isGranted &&
          status[Permission.videos]!.isGranted &&
          status[Permission.photos]!.isGranted &&
          status[Permission.manageExternalStorage]!.isGranted);
    } else {
      return status.isDenied;
    }
  }
}
