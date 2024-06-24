import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/domain/entities/entities.dart';
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

  // Cache para armazenar os resultados já calculados
  final Map<String, DirectoryContents> _cache = {};

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
      _loadDirectoryContents(_directoryStack[index]);
    }
  }

  void _handleFileSelection(FileSystemEntity fileOrDirectory) {
    if (fileOrDirectory is Directory) {
      setState(() {
        _directoryStack.add(fileOrDirectory);
        _directoryNames.add(fileOrDirectory.path.split('/').last);
      });
      _loadDirectoryContents(fileOrDirectory);
    } else {
      //TODO: Lógica de seleção de arquivos
    }
  }

  Future<void> _loadDirectoryContents(Directory directory) async {
    if (_cache.containsKey(directory.path)) {
      // Se o resultado já estiver em cache, atualize o estado diretamente
      setState(() {
        var contents = _cache[directory.path]!;
        _directoryNames.add(directory.path.split('/').last);
        _directoryStack.add(directory);
        context.read<FileBloc>().add(FileLoadedEvent(contents));
      });
    } else {
      // Caso contrário, carregue e calcule os conteúdos do diretório
      var contents = await listFilesAndDirectories(directory);
      setState(() {
        _cache[directory.path] = contents;
        _directoryNames.add(directory.path.split('/').last);
        _directoryStack.add(directory);
        context.read<FileBloc>().add(FileLoadedEvent(contents));
      });
    }
  }

  Future<DirectoryContents> listFilesAndDirectories(Directory directory) async {
    if (_cache.containsKey(directory.path)) {
      return _cache[directory.path]!;
    }

    List<Directory> directories = [];
    List<File> files = [];
    Map<Directory, int> folderCountMap = {};
    Map<Directory, int> fileCountMap = {};

    if (directory.existsSync()) {
      await for (FileSystemEntity entity in directory.list()) {
        if (entity is Directory &&
            !entity.path.split('/').last.startsWith('.') &&
            !entity.path.contains('/Android/')) {
          directories.add(entity);
        } else if (entity is File &&
            (entity.path.endsWith('.mp3') || entity.path.endsWith('.mp4'))) {
          files.add(entity);
        }
      }

      // Ordenando diretórios e arquivos
      directories.sort((a, b) => a.path.compareTo(b.path));
      files.sort((a, b) => a.path.compareTo(b.path));

      // Preenchendo folderCountMap e fileCountMap
      for (var dir in directories) {
        var contents = await listFilesAndDirectories(dir);
        folderCountMap[dir] = contents.folderCount;
        fileCountMap[dir] = contents.fileCount;
      }
    }

    var contents = DirectoryContents(
      directories: directories,
      files: files,
      folderCountMap: folderCountMap.isNotEmpty ? folderCountMap : null,
      fileCountMap: fileCountMap.isNotEmpty ? fileCountMap : null,
    );

    _cache[directory.path] = contents; // Armazenando no cache

    return contents;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        if (state is FileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FileLoaded) {
          final contents = state.directory;

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
                  itemCount: contents.directories.length + contents.files.length,
                  itemBuilder: (context, index) {
                    final item = index < contents.directories.length
                        ? contents.directories[index]
                        : contents.files[index - contents.directories.length];

                    if (item is Directory) {
                      return FolderWidget(
                        icon: Icons.folder,
                        fileOrDirectory: item,
                        folderCount: contents.getFolderCountForDirectory(item),
                        fileCount: contents.getFileCountForDirectory(item),
                        onTap: () => _handleFileSelection(item),
                      );
                    } else if (item is File) {
                      return ListTile(
                        leading: const Icon(size: 30, Icons.audiotrack_rounded),
                        title: Text(item.path.split('/').last),
                        onTap: () => _handleFileSelection(item),
                      );
                    } else {
                      return const SizedBox(); // Caso inesperado
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
          return const Center(child: Text('Nenhum arquivo de áudio encontrado'));
        }
      },
    );
  }
}
