import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/usecases/usecases.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final GetAllSongs getAllSongs;
  final PlaySong playSong;
  final PauseSong pauseSong;
  final StopSong stopSong;

  SongBloc({
    required this.getAllSongs,
    required this.playSong,
    required this.pauseSong,
    required this.stopSong,
  }) : super(SongInitial()) {
    on<LoadSongsEvent>(_onLoadSongs);
    on<PlaySongEvent>(_onPlaySong);
    on<PauseSongEvent>(_onPauseSong);
    on<StopSongEvent>(_onStopSong);
  }

  void _onLoadSongs(LoadSongsEvent event, Emitter<SongState> emit) async {
    emit(SongLoading());
    final result = await getAllSongs();
    result.fold(
      (failure) => emit(const SongError('Failed to load songs')),
      (songs) => emit(SongLoaded(songs)),
    );
  }

  void _onPlaySong(PlaySongEvent event, Emitter<SongState> emit) async {
    playSong(event.song);
    emit(SongPlaying(event.song));
  }

  void _onPauseSong(PauseSongEvent event, Emitter<SongState> emit) {
    pauseSong();
    emit(SongPaused());
  }

  void _onStopSong(StopSongEvent event, Emitter<SongState> emit) {
    stopSong();
    emit(SongStopped());
  }
}
