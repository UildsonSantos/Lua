import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  FutureOr<void> _onRequestPermission(
      RequestPermissionEvent event, Emitter<FileState> emit) async {
    final hasPermission = await requestPermission();
    if (hasPermission) {
      emit(PermissionGranted());
    } else {
      emit(PermissionDenied());
    }
  }
}
