part of 'file_bloc.dart';

sealed class FileState extends Equatable {
  const FileState();

  @override
  List<Object> get props => [];
}

final class FileInitial extends FileState {}

final class FileLoading extends FileState {}

class FileLoaded extends FileState {
  final DirectoryContents directory;
  final bool hasReachedMax;

  const FileLoaded({required this.directory, this.hasReachedMax = false});

  @override
  List<Object> get props => [directory, hasReachedMax];
}

final class FileError extends FileState {
  final String message;

  const FileError(this.message);

  @override
  List<Object> get props => [message];
}

final class PermissionGranted extends FileState {}

final class PermissionDenied extends FileState {}

class FileLoadError extends FileState {
  final String message;

  const FileLoadError(this.message);

  @override
  List<Object> get props => [message];
}
