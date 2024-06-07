import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/usecases/usecases.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final GetAllPlaylists getAllPlaylists;
  final CreatePlaylist createPlaylist;

  PlaylistBloc({
    required this.createPlaylist,
    required this.getAllPlaylists,
  }) : super(PlaylistInitial()) {
    on<LoadPlaylists>(_onLoadPlaylists);
    on<AddPlaylist>(_onAddPlaylist);
  }

  void _onLoadPlaylists(
      LoadPlaylists event, Emitter<PlaylistState> emit) async {
    emit(PlaylistLoading());
    final result = await getAllPlaylists();
    result.fold(
      (failure) => emit(const PlaylistError('Failed to load playlists')),
      (playlists) => emit(PlaylistLoaded(playlists)),
    );
  }

  void _onAddPlaylist(AddPlaylist event, Emitter<PlaylistState> emit) async {
    final result = await createPlaylist(event.playlist);
    result.fold(
      (failure) => emit(const PlaylistError('Failed to add playlist')),
      (_) => add(LoadPlaylists()),
    );
  }
}
