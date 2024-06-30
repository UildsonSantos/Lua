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
    final updatedFavorites = List<DirectoryInfo>.from(state.favorites)
      ..add(event.folder);
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
      DirectoryInfo(
        folderCount: 25,
        fileCount: 15,
        path: '/storage/emulated/0/Music',
        isFavorite: true,
      ),
      DirectoryInfo(
        folderCount: 13,
        fileCount: 2,
        path: '/storage/emulated/0/Movies',
        isFavorite: true,
      ),
      DirectoryInfo(
        folderCount: 9,
        fileCount: 24,
        path: '/storage/emulated/0/Documents',
        isFavorite: true,
      ),
      DirectoryInfo(
        fileCount: 1,
        folderCount: 142,
        path: '/storage/emulated/0/Download',
        isFavorite: true,
      ),
      DirectoryInfo(
        fileCount: 5,
        folderCount: 1,
        path: '/storage/emulated/0/DCIM',
        isFavorite: true,
      ),
    ];
    emit(FavoritesLoaded(favorites: favorites));
  }
}
