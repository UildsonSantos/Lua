abstract class FileRepository {
  Future<void> scanDirectoriesAndSaveToDatabase();
  Future<Map<String, List<dynamic>>> getDirectoryContents(String parentPath);
}
