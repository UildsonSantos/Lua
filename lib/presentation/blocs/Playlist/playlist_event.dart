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

final class UpdatePlaylistEvent extends PlaylistEvent {
  final Playlist playlist;

  const UpdatePlaylistEvent(this.playlist);

  @override
  List<Object> get props => [playlist];
}

final class DeletePlaylistEvent extends PlaylistEvent {
  final int playlistId;

  const DeletePlaylistEvent(this.playlistId);

  @override
  List<Object> get props => [playlistId];
}

final class AddSongToPlaylistEvent extends PlaylistEvent {
  final Playlist playlist;
  final Song song;

  const AddSongToPlaylistEvent(this.playlist, this.song);
}

final class RemoveSongFromPlaylistEvent extends PlaylistEvent {
  final Playlist playlist;
  final Song song;

  const RemoveSongFromPlaylistEvent(this.playlist, this.song);
}

final class RenamePlaylistEvent extends PlaylistEvent {
  final Playlist playlist;
  final String newName;

  const RenamePlaylistEvent(this.playlist, this.newName);
}

final class ReorderPlaylistEvent extends PlaylistEvent {
  final Playlist playlist;
  final int oldIndex;
  final int newIndex;

  const ReorderPlaylistEvent(this.playlist, this.oldIndex, this.newIndex);
}
