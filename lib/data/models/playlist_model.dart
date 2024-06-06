import 'package:lua/data/models/models.dart';
import 'package:lua/domain/entities/entities.dart';

class PlaylistModel extends Playlist {
  const PlaylistModel({
    super.id,
    required super.name,
    required super.songs,
  });

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      id: map['id'],
      name: map['name'],
      songs: const [], // Músicas serão adicionadas depois ao consultar o banco de dados
    );
  }

  factory PlaylistModel.fromPlaylist(Playlist playlist) {
    return PlaylistModel(
      id: playlist.id,
      name: playlist.name,
      songs: playlist.songs.map((song) => SongModel.fromSong(song)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Playlist toPlaylist() {
    return Playlist(
      id: id,
      name: name,
      songs: songs.map((songModel) => songModel).toList(),
    );
  }

  PlaylistModel copyWith({
    int? id,
    String? name,
    List<SongModel>? songs,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      songs: songs ?? this.songs,
    );
  }
}
