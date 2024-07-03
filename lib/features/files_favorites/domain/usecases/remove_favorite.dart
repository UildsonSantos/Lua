import 'package:lua/features/files_favorites/domain/repositories/repositories.dart';
import 'package:lua/shared/data/models/models.dart';

class RemoveFavorite {
  final FavoriteRepository _favoriteRepository;

  RemoveFavorite(this._favoriteRepository);

  void call(DirectoryInfo directoryInfo) {
    _favoriteRepository.removeFavorite(directoryInfo);
  }
}
