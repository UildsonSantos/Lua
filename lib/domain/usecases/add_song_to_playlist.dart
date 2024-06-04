import 'package:lua/domain/entities/entities.dart';

class AddSongToPlaylist {
  void call(Playlist playlist, Song song) {
    playlist.songs.add(song);
  }
}
