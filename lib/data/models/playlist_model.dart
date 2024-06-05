import 'package:lua/data/models/models.dart';
import 'package:lua/domain/entities/entities.dart';

class PlaylistModel extends Playlist {
  const PlaylistModel({
    super.id,
    required super.name,
    required super.songs,
  });

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
