import 'dart:io';

abstract class FileRepository {
  Future<List<FileSystemEntity>> listFilesAndDirectories(Directory directory);
  Future<bool> requestPermission();
}
