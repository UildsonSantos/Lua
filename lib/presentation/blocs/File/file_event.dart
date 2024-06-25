part of 'file_bloc.dart';

sealed class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class LoadDirectoryContentsEvent extends FileEvent {
  final DirectoryModel directory;
  final int limit;
  final int offset;

  const LoadDirectoryContentsEvent(this.directory, {this.limit = 10, this.offset = 0});

  @override
  List<Object> get props => [directory, limit, offset];
}

final class RequestPermissionEvent extends FileEvent {}

final class FileLoadedEvent extends FileEvent {
  final DirectoryContents contents;

  const FileLoadedEvent(this.contents);

  @override
  List<Object> get props => [contents];
}
