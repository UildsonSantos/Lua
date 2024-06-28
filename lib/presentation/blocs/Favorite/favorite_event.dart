part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

final class AddFavoriteEvent extends FavoriteEvent {
  final String directory;

  const AddFavoriteEvent(this.directory);

  @override
  List<Object> get props => [directory];
}
