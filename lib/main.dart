import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/features/files_explorer/domain/repositories/repositories.dart';
import 'package:lua/features/files_explorer/domain/usecases/usecases.dart';
import 'package:lua/features/files_explorer/presentation/blocs/blocs.dart';
import 'package:lua/features/files_favorites/domain/usecases/usecases.dart';
import 'package:lua/features/files_favorites/presentation/blocs/blocs.dart';
import 'package:lua/features/files_favorites/presentation/pages/pages.dart';
import 'package:lua/locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FileBloc(
            loadDirectoryContents:
                LoadDirectoryContents(GetIt.instance<FileRepository>()),
          ),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(
            addFavoriteUseCase: GetIt.instance<AddFavorite>(),
            getAllFavoritesUseCase: GetIt.instance<GetAllFavorites>(),
            removeFavoriteUseCase: GetIt.instance<RemoveFavorite>(),
          ),
        ),
      ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(favoriteBloc: FavoriteBloc(
            addFavoriteUseCase: GetIt.instance<AddFavorite>(),
            getAllFavoritesUseCase: GetIt.instance<GetAllFavorites>(),
            removeFavoriteUseCase: GetIt.instance<RemoveFavorite>(),
          ),),
      ),
    );
  }
}
