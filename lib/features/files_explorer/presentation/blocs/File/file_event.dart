part of 'file_bloc.dart';

sealed class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

final class LoadDirectoryContentsEvent extends FileEvent {
  final String directory;

  const LoadDirectoryContentsEvent(this.directory);

  @override
  List<Object> get props => [directory];
}


final class UpdateFavoritesEvent extends FileEvent {
  final List<DirectoryInfo> favorites;

  const UpdateFavoritesEvent(this.favorites);

  @override
  List<Object> get props => [favorites];
}