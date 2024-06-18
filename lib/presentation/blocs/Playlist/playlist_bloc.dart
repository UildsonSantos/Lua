import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lua/application/services/services.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/usecases/usecases.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final GetAllPlaylists getAllPlaylists;
  final CreatePlaylist createPlaylist;
  final UpdatePlaylist updatePlaylist;
  final RemovePlaylist removePlaylist;
  final PlaylistService playlistService;

  PlaylistBloc({
    required this.createPlaylist,
    required this.getAllPlaylists,
    required this.updatePlaylist,
    required this.removePlaylist,
    required this.playlistService,
  }) : super(PlaylistInitial()) {
    on<LoadPlaylistsEvent>(_onLoadPlaylists);
    on<AddPlaylistEvent>(_onAddPlaylist);
    on<UpdatePlaylistEvent>(_onUpdatePlaylist);
    on<DeletePlaylistEvent>(_onDeletePlaylist);
    on<AddSongToPlaylistEvent>(_onAddSongToPlaylist);
    on<RemoveSongFromPlaylistEvent>(_onRemoveSongFromPlaylist);
    on<RenamePlaylistEvent>(_onRenamePlaylist);
    on<ReorderPlaylistEvent>(_onReorderPlaylist);
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

  void _onAddSongToPlaylist(
      AddSongToPlaylistEvent event, Emitter<PlaylistState> emit) async {
    try {
      await playlistService.addSongToPlaylist(event.playlist, event.song);
      emit(const PlaylistSuccess('Song added successfully'));
    } catch (e) {
      emit(PlaylistError('Failed to add song: $e'));
    }
  }

  void _onRemoveSongFromPlaylist(
    RemoveSongFromPlaylistEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    try {
      await playlistService.removeSongFromPlaylist(event.playlist, event.song);
      emit(const PlaylistSuccess('Song removed successfully'));
    } catch (e) {
      emit(PlaylistError('Failed to remove song: $e'));
    }
  }

  void _onRenamePlaylist(
      RenamePlaylistEvent event, Emitter<PlaylistState> emit) async {
    try {
      await playlistService.renamePlaylist(event.playlist, event.newName);
      emit(const PlaylistSuccess('Playlist successfully renamed'));
    } catch (e) {
      emit(PlaylistError('Failed to rename Playlist: $e'));
    }
  }

  void _onReorderPlaylist(
      ReorderPlaylistEvent event, Emitter<PlaylistState> emit) async {
    try {
      await playlistService.reorderPlaylist(
        event.playlist,
        event.oldIndex,
        event.newIndex,
      );
      emit(const PlaylistSuccess('Successfully reordered playlist'));
    } catch (e) {
      emit(PlaylistError('Failed to reorder playlist: $e'));
    }
  }
}
