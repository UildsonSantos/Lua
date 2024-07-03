import 'package:lua/shared/data/models/models.dart';

abstract class FavoriteRepository {
  Future<void> addFavorite(DirectoryInfo directoryInfo);
  Future<void> removeFavorite(DirectoryInfo directoryInfo);
  Future<List<DirectoryInfo>> getFavorites();
}
