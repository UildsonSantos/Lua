import 'package:equatable/equatable.dart';

import 'package:lua/domain/entities/entities.dart';

class Playlist extends Equatable {
  final int? id;
  final String name;
  final List<Song> songs;

  const Playlist({
    this.id,
    required this.name,
    required this.songs,
  });

  @override
  List<Object> get props => [id!, name, songs];
}
