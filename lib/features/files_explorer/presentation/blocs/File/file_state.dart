part of 'file_bloc.dart';

sealed class FileState extends Equatable {
  const FileState();

  @override
  List<Object> get props => [];
}

final class FileInitial extends FileState {}

final class FileLoading extends FileState {}

final class FileLoaded extends FileState {
  final Map<String, List<dynamic>> directoryContents;

  const FileLoaded(this.directoryContents);
  @override
  List<Object> get props => [directoryContents];
}

final class FileError extends FileState {
  final String message;

  const FileError(this.message);

  @override
  List<Object> get props => [message];
}

final class FileScanned extends FileState {}
