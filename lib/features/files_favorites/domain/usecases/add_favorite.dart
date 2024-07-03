import 'package:lua/features/files_favorites/domain/repositories/repositories.dart';

class AddFavorite {
  final FavoriteRepository _favoriteRepository;

  AddFavorite(this._favoriteRepository);

  void call(String directoryPath) {
    _favoriteRepository.addFavorite(directoryPath);
  }
}
