part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  final List<DirectoryInfo> favorites;

  const FavoriteState({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

final class FavoritesInitial extends FavoriteState {
  FavoritesInitial() : super(favorites: []);
}

final class FavoritesLoaded extends FavoriteState {
  const FavoritesLoaded({required super.favorites});
}

final class FavoritesEmpty extends FavoriteState {
  FavoritesEmpty() : super(favorites: []);
}