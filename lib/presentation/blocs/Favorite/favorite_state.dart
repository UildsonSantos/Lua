part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  final List<String> favorites;

  const FavoriteState({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

class FavoritesLoadingState extends FavoriteState {
  FavoritesLoadingState() : super(favorites: []);
}

final class FavoritesLoadedState extends FavoriteState {
  const FavoritesLoadedState({required super.favorites});
}

class FavoritesEmptyState extends FavoriteState {
  FavoritesEmptyState() : super(favorites: []);
}
