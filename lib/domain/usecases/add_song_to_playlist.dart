import 'package:lua/domain/entities/entities.dart';

class AddSongToPlaylist {
  Playlist call(Playlist playlist, Song song) {
    return Playlist(
      id: playlist.id,
      name: playlist.name,
      songs: List.from(playlist.songs)..add(song),
    );
  }
}
