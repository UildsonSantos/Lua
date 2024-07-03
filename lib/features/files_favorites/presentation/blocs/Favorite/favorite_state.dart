part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoriteState {}

final class FavoritesLoaded extends FavoriteState {
  final List<DirectoryInfo> favorites;
  FavoritesLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

final class FavoritesEmpty extends FavoriteState {}
