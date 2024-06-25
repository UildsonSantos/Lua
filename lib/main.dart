import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/data/datasource/datasource.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/domain/repositories/repositories.dart';
import 'package:lua/locator.dart' as di;
import 'package:lua/presentation/blocs/blocs.dart';
import 'package:lua/presentation/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await _loadAndSaveInitialData();
  runApp(const MainApp());
}

Future<void> _loadAndSaveInitialData() async {
  final LocalDataSource localDataSource = GetIt.instance<LocalDataSource>();
  final FileRepository fileRepository = GetIt.instance<FileRepository>();

  String dirPath = '/storage/emulated/0/';
  var directory = Directory(dirPath);

  await for (var entity
      in directory.list(recursive: false, followLinks: false)) {
    // Filtrar o diretório Android/data
    if (entity is Directory && !isAndroidDataDirectory(entity)) {
      print('entity: ${entity.path}');
      var result = await countFilesAndDirectories(entity);

      DirectoryModel dirModel = DirectoryModel(
        path: entity.path,
        fileCount: result['files']!,
        folderCount: result['directories']!,
      );
      
      print('dirModel: $dirModel');
      await localDataSource.insertDirectory(dirModel);
       final subContents =
                    await fileRepository.listFilesAndDirectories(dirModel);
                subContents.fold((failure) {
                  // Handle failure
                  print(
                      'Failed to load directory contents: ${failure.message}');
                }, (subContents) async {
                  for (FileModel file in subContents.files) {
                    FileModel fileModel = FileModel(
                      id: file.id,
                      path: file.path.split('/').last,
                      directoryId: dirModel
                          .id!, // Assuming id is available after insertion
                    );
                    await localDataSource.insertFile(fileModel);
                  }
                });
    }
  }

}

Future<Map<String, int>> countFilesAndDirectories(Directory directory) async {
  int fileCount = 0;
  int dirCount = 0;

  await for (var entity
      in directory.list(recursive: false, followLinks: false)) {
    if (entity is Directory && isAndroidDataDirectory(entity)) {
      print('Ignorando diretório: ${entity.path}');
      continue;
    }

    if (entity is File) {
      fileCount++;
    } else if (entity is Directory) {
      dirCount++;
    }
  }

  return {'files': fileCount, 'directories': dirCount};
}

bool isAndroidDataDirectory(Directory directory) {
  return directory.path.contains('/Android/');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlaylistBloc>(
          create: (_) => GetIt.instance<PlaylistBloc>(),
        ),
        BlocProvider<SongBloc>(
          create: (_) => GetIt.instance<SongBloc>(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
