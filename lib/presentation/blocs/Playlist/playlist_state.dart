part of 'playlist_bloc.dart';

sealed class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object> get props => [];
}

final class PlaylistInitial extends PlaylistState {}

final class PlaylistLoading extends PlaylistState {}

final class PlaylistLoaded extends PlaylistState {
  final List<Playlist> playlists;

  const PlaylistLoaded(this.playlists);

  @override
  List<Object> get props => [playlists];
}

final class PlaylistError extends PlaylistState {
  final String message;

  const PlaylistError(this.message);

  @override
  List<Object> get props => [message];
}

final class PlaylistSuccess extends PlaylistState {
  final String message;

  const PlaylistSuccess(this.message);

  @override
  List<Object> get props => [message];
}
