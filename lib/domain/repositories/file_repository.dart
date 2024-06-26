import 'dart:io';


abstract class FileRepository {
  Future<Map<String, List<dynamic>>> listDirectoriesAndFiles(String dirPath);
  Future<Map<String, int>> countFilesAndDirectories(Directory directory);
  Future<bool> requestPermission();
}
