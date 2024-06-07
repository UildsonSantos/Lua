part of 'playlist_bloc.dart';

sealed class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object> get props => [];
}

final class LoadPlaylistsEvent extends PlaylistEvent {}

final class AddPlaylistEvent extends PlaylistEvent {
  final Playlist playlist;

  const AddPlaylistEvent(this.playlist);

  @override
  List<Object> get props => [playlist];
}

class UpdatePlaylistEvent extends PlaylistEvent {
  final Playlist playlist;

  const UpdatePlaylistEvent(this.playlist);

  @override
  List<Object> get props => [playlist];
}
