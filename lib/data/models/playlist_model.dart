import 'package:lua/domain/entities/entities.dart';

class PlaylistModel extends Playlist {
  const PlaylistModel({
    super.id,
    required super.name,
    required super.songs,
  });
}
