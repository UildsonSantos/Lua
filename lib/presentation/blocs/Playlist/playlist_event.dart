part of 'playlist_bloc.dart';

sealed class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object> get props => [];
}

final class LoadPlaylists extends PlaylistEvent {}

final class AddPlaylist extends PlaylistEvent {
  final Playlist playlist;

  const AddPlaylist(this.playlist);

  @override
  List<Object> get props => [playlist];
}