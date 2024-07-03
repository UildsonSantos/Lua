import 'package:lua/features/files_favorites/domain/repositories/repositories.dart';
import 'package:lua/shared/data/models/models.dart';

class GetAllFavorites {
  final FavoriteRepository _favoriteRepository;

  GetAllFavorites(this._favoriteRepository);

  Future<List<DirectoryInfo>> call() async {
    return await _favoriteRepository.getFavorites();
  }
}
