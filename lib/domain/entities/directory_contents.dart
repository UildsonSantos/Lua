// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';

class DirectoryContents extends Equatable {
  final List<Directory> directories;
  final List<File> files;
  final int folderCount;
  final int fileCount;

  const DirectoryContents(
    this.directories,
    this.files,
    this.folderCount,
    this.fileCount,
  );

  @override
  List<Object> get props => [directories, files, folderCount, fileCount];
}
