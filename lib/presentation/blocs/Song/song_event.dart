part of 'song_bloc.dart';

sealed class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

final class LoadSongsEvent extends SongEvent {}

final class PlaySongEvent extends SongEvent {
  final Song song;

  const PlaySongEvent(this.song);

  @override
  List<Object> get props => [song];
}

final class PauseSongEvent extends SongEvent {}

final class StopSongEvent extends SongEvent {}
