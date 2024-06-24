import 'dart:io';

import 'package:lua/domain/entities/entities.dart';

abstract class FileRepository {
  Future<List<FileSystemEntity>> listAllFileSystem(Directory directory);
  Future<DirectoryContents> listFilesAndDirectories(Directory directory);
  Future<bool> requestPermission();
}
