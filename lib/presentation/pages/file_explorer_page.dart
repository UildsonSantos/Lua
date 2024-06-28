import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/domain/repositories/repositories.dart';
import 'package:lua/domain/usecases/usecases.dart';
import 'package:lua/presentation/blocs/blocs.dart';
import 'package:lua/presentation/widgets/widgets.dart';

class FileExplorerPage extends StatelessWidget {
  final String initialDirectory;

  const FileExplorerPage({super.key, required this.initialDirectory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileBloc(
        loadDirectoryContents:
            LoadDirectoryContents(GetIt.instance<FileRepository>()),
        requestPermission: RequestPermission(GetIt.instance<FileRepository>()),
      )..add(LoadDirectoryContentsEvent(initialDirectory)),
      child: FileExplorerPageView(initialDirectory: initialDirectory),
    );
  }
}

class FileExplorerPageView extends StatefulWidget {
  final String initialDirectory;

  const FileExplorerPageView({super.key, required this.initialDirectory});

  @override
  State<FileExplorerPageView> createState() => _FileExplorerPageViewState();
}

class _FileExplorerPageViewState extends State<FileExplorerPageView> {
  late List<String> _directoryStack;
  late List<String> _directoryNames;
  bool _showButton = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _directoryStack = [widget.initialDirectory];
    _directoryNames = ['Navigator'];

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _showButton = true;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
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

  void _handleFileSelection(String fileOrDirectory) async {
    final fileBloc = context.read<FileBloc>();
    final entityType = await FileSystemEntity.type(fileOrDirectory);

    if (!mounted) return;

    switch (entityType) {
      case FileSystemEntityType.directory:
        setState(() {
          _directoryStack.add(fileOrDirectory);
          _directoryNames.add(fileOrDirectory.split('/').last);
        });
        fileBloc.add(LoadDirectoryContentsEvent(fileOrDirectory));
      case FileSystemEntityType.file:
        // TODO: Handle file selection
        break;
      case FileSystemEntityType.link:
      case FileSystemEntityType.notFound:
      case FileSystemEntityType.pipe:
      case FileSystemEntityType.unixDomainSock:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        if (state is FileLoading) {
          return const Scaffold();
        } else if (state is FileLoaded) {
          final directories = state.directoryContents['directories'];
          final audiFiles = state.directoryContents['files'];

          final contents = [...directories!, ...audiFiles!];

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
                  itemCount: contents.length,
                  itemBuilder: (context, index) {
                    if (contents[index] is DirectoryInfo) {
                      return FolderWidget(
                        icon: Icons.folder,
                        fileOrDirectory: contents[index].path,
                        folderCount: contents[index].folderCount,
                        fileCount: contents[index].fileCount,
                        onTap: () => _handleFileSelection(contents[index].path),
                      );
                    } else {
                      return ListTile(
                        leading: const Icon(size: 30, Icons.audiotrack_rounded),
                        title: Text(contents[index].path.split('/').last),
                        onTap: () => _handleFileSelection(contents[index].path),
                      );
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
                      child: const Icon(Icons.play_circle_rounded),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        } else if (state is PermissionDenied) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Permissão de acesso negada.'),
                  const Text(
                      'O Aplicativo precida da permissão do usuario para ler arquivos de audio.'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FileBloc>().add(RequestPermissionEvent());
                    },
                    child: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('Nenhum arquivo de áudio encontrado!')),
          );
        }
      },
    );
  }
}
