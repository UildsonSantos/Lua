part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

final class AddFavoriteEvent extends FavoriteEvent {
  final DirectoryInfo folder;

  const AddFavoriteEvent({
    required this.folder,
  });

  @override
  List<Object> get props => [folder];
}

final class RemoveFavoriteEvent extends FavoriteEvent {
 final DirectoryInfo folder;

  const RemoveFavoriteEvent({required this.folder});
}

final class LoadFavoritesEvent extends FavoriteEvent {}
