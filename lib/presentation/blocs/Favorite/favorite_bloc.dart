import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoritesLoadingState()) {
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<LoadFavoritesEvent>(_onLoadFavorites);
  }

  void _onAddFavorite(AddFavoriteEvent event, Emitter<FavoriteState> emit) {
    final favorites = [...state.favorites, event.directory];
    emit(FavoritesLoadedState(favorites: favorites));
  }

  void _onRemoveFavorite(
      RemoveFavoriteEvent event, Emitter<FavoriteState> emit) {
    final favorites =
        state.favorites.where((dir) => dir != event.directory).toList();
    emit(FavoritesLoadedState(favorites: favorites));
  }

  void _onLoadFavorites(LoadFavoritesEvent event, Emitter<FavoriteState> emit) {
    final favorites = [
      '/storage/emulated/0/Movies',
      '/storage/emulated/0/Music',
      '/storage/emulated/0/Documents',
      '/storage/emulated/0/Download',
      '/storage/emulated/0/DCIM'
    ];
    emit(FavoritesLoadedState(favorites: favorites));
  }


}
