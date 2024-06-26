import 'package:lua/domain/repositories/repositories.dart';

class LoadDirectoryContents {
  final FileRepository repository;

  LoadDirectoryContents(this.repository);

  Future<Map<String, List<dynamic>>> call(String dirPath) async {
    return await repository.listDirectoriesAndFiles(dirPath);
  }
}
