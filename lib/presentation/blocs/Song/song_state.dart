part of 'song_bloc.dart';

sealed class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

final class SongInitial extends SongState {}

final class SongLoading extends SongState {}

final class SongLoaded extends SongState {
  final List<Song> songs;

  const SongLoaded(this.songs);

  @override
  List<Object> get props => [songs];
}

final class SongError extends SongState {
  final String message;

  const SongError(this.message);

  @override
  List<Object> get props => [message];
}

final class SongPlaying extends SongState {
  final Song song;

  const SongPlaying(this.song);

  @override
  List<Object> get props => [song];
}

final class SongPaused extends SongState {}

final class SongStopped extends SongState {}

final class SongCompleted extends SongState {} 
