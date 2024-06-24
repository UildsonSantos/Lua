import 'dart:io';

import 'package:equatable/equatable.dart';

class DirectoryContents extends Equatable {
  final List<Directory> directories;
  final List<File> files;

  const DirectoryContents(this.directories, this.files);

  @override
  List<Object> get props => [directories, files];
}
