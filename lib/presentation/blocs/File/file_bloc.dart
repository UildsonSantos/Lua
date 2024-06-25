import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/usecases/usecases.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final LoadDirectoryContents loadDirectoryContents;
  final RequestPermission requestPermission;

  FileBloc({
    required this.loadDirectoryContents,
    required this.requestPermission,
  }) : super(FileInitial()) {
    on<LoadDirectoryContentsEvent>(_onLoadDirectoryContents);
    on<RequestPermissionEvent>(_onRequestPermission);
    on<FileLoadedEvent>(_onFileLoaded);
  }

  Future<void> _onLoadDirectoryContents(
      LoadDirectoryContentsEvent event, Emitter<FileState> emit) async {
    final currentState = state;
    List<DirectoryModel> directories = [];
    List<FileModel> files = [];
    bool hasReachedMax = false;

    if (currentState is FileLoaded) {
      directories = currentState.directory.directories;
      files = currentState.directory.files;
      hasReachedMax = currentState.hasReachedMax;
    }

    try {
      final result = await loadDirectoryContents(
        event.directory,
        event.limit,
        event.offset,
      );

      result.fold(
        (failure) => emit(FileLoadError(failure.message)),
        (directoryContents) {
          directories.addAll(directoryContents.directories);
          files.addAll(directoryContents.files);
          hasReachedMax = directoryContents.directories.isEmpty &&
              directoryContents.files.isEmpty;
          emit(FileLoaded(
            directory: DirectoryContents(
              directories: directories,
              files: files,
            ),
            hasReachedMax: hasReachedMax,
          ));
        },
      );
    } catch (e) {
      emit(FileLoadError('Failed to load directory contents: $e'));
    }
  }

  Future<void> _onRequestPermission(
      RequestPermissionEvent event, Emitter<FileState> emit) async {
    final hasPermission = await requestPermission();
    if (hasPermission) {
      emit(PermissionGranted());
    } else {
      emit(PermissionDenied());
    }
  }

  void _onFileLoaded(FileLoadedEvent event, Emitter<FileState> emit) {
    emit(FileLoaded(directory: event.contents));
  }
}
