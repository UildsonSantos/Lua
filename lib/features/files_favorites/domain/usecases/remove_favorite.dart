import 'package:lua/features/files_favorites/domain/repositories/repositories.dart';

class RemoveFavorite {
  final FavoriteRepository _favoriteRepository;

  RemoveFavorite(this._favoriteRepository);

  void call(String directoryPath) {
    _favoriteRepository.removeFavorite(directoryPath);
  }
}
