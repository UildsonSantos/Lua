part of 'file_bloc.dart';

sealed class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

final class LoadDirectoryContentsEvent extends FileEvent {
  final Directory directory;

  const LoadDirectoryContentsEvent(this.directory);

  @override
  List<Object> get props => [directory];
}

final class RequestPermissionEvent extends FileEvent {}

final class FileLoadedEvent extends FileEvent {
  final DirectoryContents contents;

  const FileLoadedEvent(this.contents);

  @override
  List<Object> get props => [contents];
}
