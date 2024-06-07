import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/usecases/usecases.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final GetAllPlaylists getAllPlaylists;
  final CreatePlaylist createPlaylist;
  final UpdatePlaylist updatePlaylist;
  final RemovePlaylist removePlaylist;

  PlaylistBloc({
    required this.createPlaylist,
    required this.getAllPlaylists,
    required this.updatePlaylist,
    required this.removePlaylist,
  }) : super(PlaylistInitial()) {
    on<LoadPlaylistsEvent>(_onLoadPlaylists);
    on<AddPlaylistEvent>(_onAddPlaylist);
    on<UpdatePlaylistEvent>(_onUpdatePlaylist);
    on<DeletePlaylistEvent>(_onDeletePlaylist);
  }

  void _onLoadPlaylists(
      LoadPlaylistsEvent event, Emitter<PlaylistState> emit) async {
    emit(PlaylistLoading());
    final result = await getAllPlaylists();
    result.fold(
      (failure) => emit(const PlaylistError('Failed to load playlists')),
      (playlists) => emit(PlaylistLoaded(playlists)),
    );
  }

  void _onAddPlaylist(
      AddPlaylistEvent event, Emitter<PlaylistState> emit) async {
    final result = await createPlaylist(event.playlist);
    result.fold(
      (failure) => emit(const PlaylistError('Failed to add playlist')),
      (_) => add(LoadPlaylistsEvent()),
    );
  }

  void _onUpdatePlaylist(
      UpdatePlaylistEvent event, Emitter<PlaylistState> emit) async {
    emit(PlaylistLoading());
    final result = await updatePlaylist(event.playlist);
    result.fold(
      (failure) => emit(const PlaylistError('Failed to update playlist')),
      (_) => add(LoadPlaylistsEvent()),
    );
  }

  void _onDeletePlaylist(
      DeletePlaylistEvent event, Emitter<PlaylistState> emit) async {
    final result = await removePlaylist(event.playlistId);
    result.fold(
      (failure) => emit(const PlaylistError('Failed to delete playlist')),
      (_) => add(LoadPlaylistsEvent()),
    );
  }
}
