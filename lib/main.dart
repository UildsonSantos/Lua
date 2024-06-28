import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/domain/repositories/repositories.dart';
import 'package:lua/domain/usecases/usecases.dart';
import 'package:lua/locator.dart' as di;
import 'package:lua/presentation/blocs/blocs.dart';
import 'package:lua/presentation/pages/pages.dart';

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
            requestPermission:
                RequestPermission(GetIt.instance<FileRepository>()),
          ),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
