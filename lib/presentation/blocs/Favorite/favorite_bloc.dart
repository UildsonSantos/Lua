import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/data/models/models.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoritesInitial()) {
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<LoadFavoritesEvent>(_onLoadFavorites);
  }

  void _onAddFavorite(AddFavoriteEvent event, Emitter<FavoriteState> emit) {
    final List<DirectoryInfo> currentFavorites = state.favorites;
    final DirectoryInfo newFolder = event.folder.copyWith(isFavorite: true);

    if (currentFavorites.any((folder) => folder.path == newFolder.path)) {
      return;
    }

    final updatedFavorites = List<DirectoryInfo>.from(currentFavorites)
      ..add(newFolder);

    emit(FavoritesLoaded(favorites: updatedFavorites));
  }

  void _onRemoveFavorite(
      RemoveFavoriteEvent event, Emitter<FavoriteState> emit) {
    final favorites =
        state.favorites.where((dir) => dir != event.folder).toList();
    emit(FavoritesLoaded(favorites: favorites));
  }

  void _onLoadFavorites(LoadFavoritesEvent event, Emitter<FavoriteState> emit) {
    final favorites = [
      const DirectoryInfo(
        folderCount: 25,
        fileCount: 15,
        path: '/storage/emulated/0/Music',
        isFavorite: true,
      ),
      const DirectoryInfo(
        folderCount: 13,
        fileCount: 2,
        path: '/storage/emulated/0/Movies',
        isFavorite: true,
      ),
      
    ];
    emit(FavoritesLoaded(favorites: favorites));
  }
}
