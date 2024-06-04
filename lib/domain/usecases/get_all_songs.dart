import 'package:lua/domain/entities/entities.dart';
import 'package:lua/domain/repositories/repositories.dart';

class GetAllSongs {
  final SongRepository repository;

  GetAllSongs(this.repository);

  Future<List<Song>> call() async {
    return await repository.getAllSongs();
  }
}
