import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/domain/repositories/repositories.dart';
import 'package:lua/domain/usecases/usecases.dart';
import 'package:lua/presentation/blocs/blocs.dart';

class FileExplorerPage extends StatelessWidget {
  const FileExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileBloc(
        loadDirectoryContents:
            LoadDirectoryContents(GetIt.instance<FileRepository>()),
        requestPermission: RequestPermission(GetIt.instance<FileRepository>()),
      )..add(RequestPermissionEvent()),
      child: const FileExplorerPageView(),
    );
  }
}

class FileExplorerPageView extends StatefulWidget {
  const FileExplorerPageView({super.key});

  @override
  State<FileExplorerPageView> createState() => _FileExplorerPageViewState();
}

class _FileExplorerPageViewState extends State<FileExplorerPageView> {
  @override
  void initState() {
    super.initState();
    context.read<FileBloc>().stream.listen((state) {
      if (state is PermissionGranted) {
        context
            .read<FileBloc>()
            .add(LoadDirectoryContentsEvent(Directory('/storage/emulated/0')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LUA'),
      ),
      body: BlocBuilder<FileBloc, FileState>(
        builder: (context, state) {
          if (state is FileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FileLoaded) {
            return ListView.builder(
              itemCount: state.files.length,
              itemBuilder: (context, index) {
                final fileOrDirectory = state.files[index];
                return ListTile(
                  title: Text(fileOrDirectory.path.split('/').last),
                  onTap: () {
                    // Ação ao clicar no arquivo ou diretório
                  },
                );
              },
            );
          } else if (state is PermissionDenied) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Permissão de acesso negada.'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FileBloc>().add(RequestPermissionEvent());
                    },
                    child: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
                child: Text('Nenhum arquivo de áudio encontrado'));
          }
        },
      ),
    );
  }
}
