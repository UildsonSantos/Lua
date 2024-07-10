import 'package:get_it/get_it.dart';
import 'package:lua/features/files_explorer/data/dao/dao.dart';
import 'package:lua/features/files_explorer/data/repositories/repositories.dart';
import 'package:lua/features/files_explorer/domain/repositories/repositories.dart';
import 'package:lua/features/files_explorer/domain/usecases/usecases.dart';
import 'package:lua/features/files_explorer/presentation/blocs/blocs.dart';
import 'package:lua/features/files_favorites/data/dao/dao.dart';
import 'package:lua/features/files_favorites/data/repositories/repositories.dart';
import 'package:lua/features/files_favorites/domain/repositories/repositories.dart';
import 'package:lua/features/files_favorites/domain/usecases/usecases.dart';
import 'package:lua/features/files_favorites/presentation/blocs/blocs.dart';
import 'package:lua/shared/domain/usecases/usecases.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton<RequestPermission>(() => RequestPermission());

  // Data sources
  sl.registerLazySingleton<FavoritesDAO>(() => FavoritesDAO());
  sl.registerLazySingleton<FileDAO>(() => FileDAO());

  // Repositories
  sl.registerLazySingleton<FileRepository>(
      () => FileRepositoryImpl(sl<RequestPermission>(), sl<FileDAO>()));
  sl.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(sl<FavoritesDAO>()));

  // UseCases
  sl.registerLazySingleton<AddFavorite>(
      () => AddFavorite(sl<FavoriteRepository>()));
  sl.registerLazySingleton<GetAllFavorites>(
      () => GetAllFavorites(sl<FavoriteRepository>()));
  sl.registerLazySingleton<RemoveFavorite>(
      () => RemoveFavorite(sl<FavoriteRepository>()));

  sl.registerLazySingleton<LoadDirectoryContents>(
      () => LoadDirectoryContents(sl<FileRepository>()));

  // BLoCs

  sl.registerFactory(
    () => FavoriteBloc(
      addFavoriteUseCase: sl<AddFavorite>(),
      getAllFavoritesUseCase: sl<GetAllFavorites>(),
      removeFavoriteUseCase: sl<RemoveFavorite>(),
    ),
  );

  sl.registerFactory(
    () => FileBloc(
      loadDirectoryContents: sl<LoadDirectoryContents>(),
      favoriteBloc: sl<FavoriteBloc>(),
    ),
  );
}
