import 'package:lua/shared/data/models/models.dart';

abstract class FavoriteRepository {
  Future<void> addFavorite(String directoryPath);
  Future<void> removeFavorite(String directoryPath);
  Future<List<DirectoryInfo>> getFavorites();
}
