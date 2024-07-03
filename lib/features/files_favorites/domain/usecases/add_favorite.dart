import 'package:lua/features/files_favorites/domain/repositories/repositories.dart';
import 'package:lua/shared/data/models/models.dart';

class AddFavorite {
  final FavoriteRepository _favoriteRepository;

  AddFavorite(this._favoriteRepository);

  void call(DirectoryInfo directoryInfo) {
    _favoriteRepository.addFavorite(directoryInfo);
  }
}
