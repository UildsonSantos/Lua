import 'package:lua/features/files_explorer/domain/repositories/repositories.dart';

class LoadDirectoryContents {
  final FileRepository repository;

  LoadDirectoryContents(this.repository);

  Future<Map<String, List<dynamic>>> call(String dirPath) async {
    return await repository.getDirectoryContents(dirPath);
  }
}
