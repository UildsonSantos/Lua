import 'package:equatable/equatable.dart';

import 'package:lua/domain/entities/entities.dart';

class Playlist extends Equatable {
  final String id;
  final String name;
  final List<Song> songs;

  const Playlist({
    required this.id,
    required this.name,
    required this.songs,
  });

  @override
  List<Object> get props => [id, name, songs];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map, List<Song> songs) {
    return Playlist(
      id: map['id'],
      name: map['name'],
      songs: songs,
    );
  }

  Playlist copyWith({
    String? id,
    String? name,
    List<Song>? songs,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      songs: songs ?? this.songs,
    );
  }
}
