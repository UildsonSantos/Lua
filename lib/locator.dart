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
  // sl.registerLazySingleton<MusicPlayerService>(() => MusicPlayerService());
  // sl.registerLazySingleton<PlaylistService>(
  //     () => PlaylistServiceImpl(sl<PlaylistRepository>()));
  sl.registerLazySingleton<RequestPermission>(() => RequestPermission());

  // Data sources
  // sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  // sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  // sl.registerLazySingleton<MusicFileDataSource>(() => MusicFileDataSource());
  sl.registerLazySingleton<FavoritesDAO>(() => FavoritesDAO());
  sl.registerLazySingleton<FileDAO>(() => FileDAO());

  // Repositories
  // sl.registerLazySingleton<PlaylistRepository>(
  //     () => PlaylistRepositoryImpl(sl<LocalDataSource>()));
  // sl.registerLazySingleton<SongRepository>(() =>
  //     SongRepositoryImpl(sl<LocalDataSource>(), sl<MusicFileDataSource>()));
  sl.registerLazySingleton<FileRepository>(
      () => FileRepositoryImpl(sl<RequestPermission>(), sl<FileDAO>() ));
  sl.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(sl<FavoritesDAO>()));
 

  // UseCases
  // sl.registerLazySingleton<CreatePlaylist>(
  //     () => CreatePlaylist(sl<PlaylistRepository>()));
  // sl.registerLazySingleton<GetAllPlaylists>(
  //     () => GetAllPlaylists(sl<PlaylistRepository>()));
  // sl.registerLazySingleton<UpdatePlaylist>(
  //     () => UpdatePlaylist(sl<PlaylistRepository>()));
  // sl.registerLazySingleton<RemovePlaylist>(
  //     () => RemovePlaylist(sl<PlaylistRepository>()));
  sl.registerLazySingleton<AddFavorite>(
      () => AddFavorite(sl<FavoriteRepository>()));
  sl.registerLazySingleton<GetAllFavorites>(
      () => GetAllFavorites(sl<FavoriteRepository>()));
  sl.registerLazySingleton<RemoveFavorite>(
      () => RemoveFavorite(sl<FavoriteRepository>()));

  sl.registerLazySingleton<LoadDirectoryContents>(
      () => LoadDirectoryContents(sl<FileRepositoryImpl>()));

  // sl.registerLazySingleton<GetAllSongs>(
  //     () => GetAllSongs(sl<SongRepository>()));
  // sl.registerLazySingleton<PauseSong>(
  //     () => PauseSong(sl<MusicPlayerService>()));
  // sl.registerLazySingleton<PlaySong>(() => PlaySong(sl<MusicPlayerService>()));
  // sl.registerLazySingleton<StopSong>(() => StopSong(sl<MusicPlayerService>()));

  // BLoCs
  // sl.registerFactory(
  //   () => PlaylistBloc(
  //     getAllPlaylists: sl<GetAllPlaylists>(),
  //     createPlaylist: sl<CreatePlaylist>(),
  //     updatePlaylist: sl<UpdatePlaylist>(),
  //     removePlaylist: sl<RemovePlaylist>(),
  //     playlistService: sl<PlaylistService>(),
  //   ),
  // );

  // sl.registerFactory(
  //   () => SongBloc(
  //     getAllSongs: sl<GetAllSongs>(),
  //     playSong: sl<PlaySong>(),
  //     pauseSong: sl<PauseSong>(),
  //     stopSong: sl<StopSong>(),
  //   ),
  // );

  sl.registerFactory(
    () => FileBloc(
      loadDirectoryContents: sl<LoadDirectoryContents>(),
    ),
  );

  sl.registerFactory(
    () => FavoriteBloc(
      addFavoriteUseCase: sl<AddFavorite>(),
      getAllFavoritesUseCase: sl<GetAllFavorites>(),
      removeFavoriteUseCase: sl<RemoveFavorite>(),
    ),
  );
}
