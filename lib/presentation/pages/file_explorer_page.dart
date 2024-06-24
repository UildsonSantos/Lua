import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/domain/repositories/repositories.dart';
import 'package:lua/domain/usecases/usecases.dart';
import 'package:lua/presentation/blocs/blocs.dart';
import 'package:lua/presentation/widgets/widgets.dart';

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
  final List<Directory> _directoryStack = [Directory('/storage/emulated/0')];
  final List<String> _directoryNames = ['Navigator'];
  bool _showButton = true;
  late ScrollController _scrollController;

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
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose o ScrollController ao finalizar
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // Scroll para cima
      setState(() {
        _showButton = true;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Scroll para baixo
      setState(() {
        _showButton = false;
      });
    }
  }

  void _navigateToDirectory(int index) {
    if (index < _directoryStack.length) {
      setState(() {
        _directoryStack.removeRange(index + 1, _directoryStack.length);
        _directoryNames.removeRange(index + 1, _directoryNames.length);
      });
      context
          .read<FileBloc>()
          .add(LoadDirectoryContentsEvent(_directoryStack[index]));
    }
  }

  void _handleFileSelection(FileSystemEntity fileOrDirectory) {
    if (fileOrDirectory is Directory) {
      setState(() {
        _directoryStack.add(fileOrDirectory);
        _directoryNames.add(fileOrDirectory.path.split('/').last);
      });
      context.read<FileBloc>().add(LoadDirectoryContentsEvent(fileOrDirectory));
    } else {
      //TODO: Lógica de seleção de arquivos
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        if (state is FileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FileLoaded) {
          final directories = state.directory.directories;
          final files = state.directory.files;
          final folderCountMap = state.directory.folderCountMap;
          final fileCountMap = state.directory.fileCountMap;

          return Scaffold(
            appBar: AppBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < _directoryNames.length; i++)
                      GestureDetector(
                        onTap: () => _navigateToDirectory(i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _directoryNames[i],
                                style: const TextStyle(fontSize: 15.0),
                              ),
                              if (i < _directoryNames.length - 1)
                                const Icon(Icons.chevron_right, size: 24.0),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: directories.length + files.length,
                  itemBuilder: (context, index) {
                    if (index < directories.length) {
                      final directory = directories[index];
                      return FolderWidget(
                        icon: Icons.folder,
                        fileOrDirectory: directory,
                        folderCount: folderCountMap[directory] ?? 0,
                        fileCount: fileCountMap[directory] ?? 0,
                        onTap: () => _handleFileSelection(directory),
                      );
                    } else {
                      final fileIndex = index - directories.length;
                      final file = files[fileIndex];
                      if (file.path.endsWith('.mp3') ||
                          file.path.endsWith('.mp4')) {
                        return ListTile(
                          leading:
                              const Icon(size: 30, Icons.audiotrack_rounded),
                          title: Text(file.path.split('/').last),
                          onTap: () => _handleFileSelection(file),
                        );
                      } else {
                        return ListTile(
                          leading: const Icon(
                              size: 30, Icons.sd_card_alert_outlined),
                          title: Text(file.path.split('/').last),
                          onTap: () => _handleFileSelection(file),
                        );
                      }
                    }
                  },
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    iconSize: 60,
                    color: Colors.orange.shade900,
                    icon: AnimatedScale(
                      scale: _showButton ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.play_circle_rounded,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
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
    );
  }
}
