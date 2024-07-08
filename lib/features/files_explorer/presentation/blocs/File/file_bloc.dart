import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/features/files_explorer/domain/usecases/usecases.dart';
import 'package:lua/features/files_favorites/presentation/blocs/blocs.dart';
import 'package:lua/shared/data/models/models.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final LoadDirectoryContents loadDirectoryContents;
  final FavoriteBloc favoriteBloc;

  FileBloc({
    required this.loadDirectoryContents,
    required this.favoriteBloc,
  }) : super(FileInitial()) {
    on<LoadDirectoryContentsEvent>(_onLoadDirectoryContents);
    on<UpdateFavoritesEvent>(_onUpdateFavorites);

    favoriteBloc.stream.listen((state) {
      if (state is FavoritesLoaded) {
        add(UpdateFavoritesEvent(state.favorites));
      }
    });
  }

  FutureOr<void> _onLoadDirectoryContents(
      LoadDirectoryContentsEvent event, Emitter<FileState> emit) async {
    emit(FileLoading());
    try {
      final directoryContents = await loadDirectoryContents(event.directory);
      emit(FileLoaded(directoryContents));
    } catch (_) {
      emit(const FileError('Error ao carregar diretorio.'));
    }
  }

  FutureOr<void> _onUpdateFavorites(
      UpdateFavoritesEvent event, Emitter<FileState> emit) async {
    if (state is FileLoaded) {
      final currentState = state as FileLoaded;
      final updatedContents = currentState.directoryContents.map((key, value) {
        final updatedValue = value.map((file) {
          if (event.favorites.any((fav) => fav.path == file.path)) {
            return file.copyWith(isFavorite: true);
          } else {
            return file.copyWith(isFavorite: false);
          }
        }).toList();
        return MapEntry(key, updatedValue);
      });
      emit(FileLoaded(updatedContents));
    }
  }
}
