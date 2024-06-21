part of 'file_bloc.dart';

sealed class FileState extends Equatable {
  const FileState();

  @override
  List<Object> get props => [];
}

final class FileInitial extends FileState {}

final class FileLoading extends FileState {}

final class FileLoaded extends FileState {
  final List<FileSystemEntity> files;

  const FileLoaded(this.files);

  @override
  List<Object> get props => [files];
}

final class FileError extends FileState {
  final String message;

  const FileError(this.message);

  @override
  List<Object> get props => [message];
}

final class PermissionGranted extends FileState {}

final class PermissionDenied extends FileState {}
