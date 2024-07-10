import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/features/files_explorer/domain/repositories/repositories.dart';
import 'package:lua/features/files_favorites/presentation/blocs/blocs.dart';
import 'package:lua/features/files_favorites/presentation/pages/pages.dart';
import 'package:lua/locator.dart' as di;

import 'features/files_explorer/presentation/blocs/blocs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
   final fileRepository = GetIt.instance<FileRepository>();
  await fileRepository.scanDirectoriesAndSaveToDatabase();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance<FileBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance<FavoriteBloc>(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
