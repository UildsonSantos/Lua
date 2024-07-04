import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lua/features/files_favorites/domain/usecases/usecases.dart';
import 'package:lua/shared/data/models/models.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AddFavorite addFavoriteUseCase;
  final GetAllFavorites getAllFavoritesUseCase;
  final RemoveFavorite removeFavoriteUseCase;

  FavoriteBloc({
    required this.addFavoriteUseCase,
    required this.getAllFavoritesUseCase,
    required this.removeFavoriteUseCase,
  }) : super(FavoritesInitial()) {
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<LoadFavoritesEvent>(_onLoadFavorites);
  }

  void _onAddFavorite(
      AddFavoriteEvent event, Emitter<FavoriteState> emit) async {
    addFavoriteUseCase.call(event.folder);
    final favorites = await getAllFavoritesUseCase.call();
    emit(FavoritesLoaded(favorites: favorites));
  }

  void _onRemoveFavorite(
      RemoveFavoriteEvent event, Emitter<FavoriteState> emit) async {
    removeFavoriteUseCase.call(event.folder);
    final favorites = await getAllFavoritesUseCase.call();
    emit(FavoritesLoaded(favorites: favorites));
  }

  void _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    final favorites = await getAllFavoritesUseCase.call();
    if (favorites.isEmpty) {
      emit(FavoritesEmpty());
    } else {
      emit(FavoritesLoaded(favorites: favorites));
    }
  }
}
