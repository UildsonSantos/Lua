import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/usecases/usecases.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final GetAllSongs getAllSongs;

  SongBloc({
    required this.getAllSongs,
  }) : super(SongInitial()) {
    on<LoadSongsEvent>(_onLoadSongs);
  }

  void _onLoadSongs(LoadSongsEvent event, Emitter<SongState> emit) async {
    emit(SongLoading());
    final result = await getAllSongs();
    result.fold(
      (failure) => emit(const SongError('Failed to load songs')),
      (songs) => emit(SongLoaded(songs)),
    );
  }
}
