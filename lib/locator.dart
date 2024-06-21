import 'package:get_it/get_it.dart';
import 'package:lua/application/services/services.dart';
import 'package:lua/data/datasource/datasource.dart';
import 'package:lua/data/repositories/repositories.dart';
import 'package:lua/data/sources/souces.dart';
import 'package:lua/domain/repositories/repositories.dart';
import 'package:lua/domain/usecases/usecases.dart';
import 'package:lua/presentation/blocs/blocs.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton<MusicPlayerService>(() => MusicPlayerService());
  sl.registerLazySingleton<PlaylistService>(
      () => PlaylistServiceImpl(sl<PlaylistRepository>()));

  // Data sources
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  sl.registerLazySingleton<MusicFileDataSource>(() => MusicFileDataSource());

  // Repositories
  sl.registerLazySingleton<PlaylistRepository>(
      () => PlaylistRepositoryImpl(sl<LocalDataSource>()));
  sl.registerLazySingleton<SongRepository>(() =>
      SongRepositoryImpl(sl<LocalDataSource>(), sl<MusicFileDataSource>()));
  sl.registerLazySingleton<FileRepository>(
      () => FileRepositoryImpl(sl<MusicFileDataSource>()));

  // UseCases
  sl.registerLazySingleton<CreatePlaylist>(
      () => CreatePlaylist(sl<PlaylistRepository>()));
  sl.registerLazySingleton<GetAllPlaylists>(
      () => GetAllPlaylists(sl<PlaylistRepository>()));
  sl.registerLazySingleton<UpdatePlaylist>(
      () => UpdatePlaylist(sl<PlaylistRepository>()));
  sl.registerLazySingleton<RemovePlaylist>(
      () => RemovePlaylist(sl<PlaylistRepository>()));

  sl.registerLazySingleton<LoadDirectoryContents>(
      () => LoadDirectoryContents(sl<FileRepository>()));
  sl.registerLazySingleton<RequestPermission>(
      () => RequestPermission(sl<FileRepository>()));

  sl.registerLazySingleton<GetAllSongs>(
      () => GetAllSongs(sl<SongRepository>()));
  sl.registerLazySingleton<PauseSong>(
      () => PauseSong(sl<MusicPlayerService>()));
  sl.registerLazySingleton<PlaySong>(() => PlaySong(sl<MusicPlayerService>()));
  sl.registerLazySingleton<StopSong>(() => StopSong(sl<MusicPlayerService>()));

  // BLoCs
  sl.registerFactory(
    () => PlaylistBloc(
      getAllPlaylists: sl<GetAllPlaylists>(),
      createPlaylist: sl<CreatePlaylist>(),
      updatePlaylist: sl<UpdatePlaylist>(),
      removePlaylist: sl<RemovePlaylist>(),
      playlistService: sl<PlaylistService>(),
    ),
  );

  sl.registerFactory(
    () => SongBloc(
      getAllSongs: sl<GetAllSongs>(),
      playSong: sl<PlaySong>(),
      pauseSong: sl<PauseSong>(),
      stopSong: sl<StopSong>(),
    ),
  );

  sl.registerFactory(
    () => FileBloc(
      loadDirectoryContents: sl<LoadDirectoryContents>(),
      requestPermission: sl<RequestPermission>(),
    ),
  );
}
