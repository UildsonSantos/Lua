import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/features/files_explorer/domain/usecases/usecases.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final LoadDirectoryContents loadDirectoryContents;

  FileBloc({
    required this.loadDirectoryContents,
  }) : super(FileInitial()) {
    on<LoadDirectoryContentsEvent>(_onLoadDirectoryContents);
  }

  FutureOr<void> _onLoadDirectoryContents(
      LoadDirectoryContentsEvent event, Emitter<FileState> emit) async {
    emit(FileLoading());
    try {
      final directoryContents = await loadDirectoryContents(event.directory);
      emit(FileLoaded(directoryContents));
    } catch (_) {
      emit(const FileError('Error ao carregar diretorio.'));
    }
  }
}
