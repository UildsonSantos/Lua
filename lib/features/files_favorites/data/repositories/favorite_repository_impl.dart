import 'package:lua/features/files_favorites/data/dao/dao.dart';
import 'package:lua/features/files_favorites/domain/repositories/repositories.dart';
import 'package:lua/shared/data/models/models.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoritesDAO _favoritesDAO;

  FavoriteRepositoryImpl(this._favoritesDAO);

  @override
  Future<void> addFavorite(DirectoryInfo directoryInfo) async {
    await _favoritesDAO.addToFavorites(directoryInfo.path);
  }

  @override
  Future<List<DirectoryInfo>> getFavorites() async {
    return await _favoritesDAO.getFavoriteDirectories();
  }

  @override
  Future<void> removeFavorite(DirectoryInfo directoryInfo) async {
    await _favoritesDAO.removeFromFavorites(directoryInfo.path);
  }
}
