import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/features/files_explorer/presentation/blocs/blocs.dart';
import 'package:lua/shared/data/models/models.dart';
import 'package:lua/shared/presentation/widgets/widgets.dart';
import 'package:path/path.dart' as p;

class FileExplorerPage extends StatelessWidget {
  final String initialDirectory;

  const FileExplorerPage({super.key, required this.initialDirectory});

  @override
  Widget build(BuildContext context) {
    final fileBloc = BlocProvider.of<FileBloc>(context);

    fileBloc.add(LoadDirectoryContentsEvent(initialDirectory));

    return BlocProvider.value(
      value: fileBloc,
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
  final List<String> _directoryNames = ['Navigator'];
  bool _showButton = true;
  late ScrollController _scrollController;
  final Set<String> _selectedItems = {};
  bool _multiSelectMode = false;
  bool _showSelectedItemsSheet = false;

  @override
  void initState() {
    super.initState();
    _directoryStack = [widget.initialDirectory];

    if (widget.initialDirectory.split('/').last != '0') {
      _directoryNames.add(widget.initialDirectory.split('/').last);
    }

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

  void _toggleSelection(String path) {
    setState(() {
      if (_selectedItems.contains(path)) {
        _selectedItems.remove(path);
      } else {
        _selectedItems.add(path);
      }
    });
  }

  void _toggleMultiSelectMode(String path) {
    setState(() {
      if (_multiSelectMode) {
        _toggleSelection(path);
      } else {
        _multiSelectMode = true;
        _toggleSelection(path);
      }
    });
  }

  void _toggleSelectedItemsSheet() {
    setState(() {
      _showSelectedItemsSheet = !_showSelectedItemsSheet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        if (state is FileLoading) {
          return const Scaffold();
        } else if (state is FileLoaded) {
          final directories = state.directoryContents['directories'];
          final audioFiles = state.directoryContents['files'];

          final contents = [...directories!, ...audioFiles!];

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
                    final item = contents[index];
                    return InkWell(
                      onLongPress: () => _toggleMultiSelectMode(item['path']),
                      child: Container(
                        color: _selectedItems.contains(item['path'])
                            ? Colors.grey.shade400
                            : Colors.transparent,
                        child: FolderWidget(
                          directoryInfo: DirectoryInfo.fromMap(contents[index]),
                          onTap: () => _multiSelectMode
                              ? _toggleSelection(item['path'])
                              : _handleFileSelection(contents[index]['path']),
                        ),
                      ),
                    );
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
                    onPressed: _toggleSelectedItemsSheet,
                  ),
                ),
                if (_showSelectedItemsSheet)
                  DraggableScrollableSheet(
                    initialChildSize: 1,
                    minChildSize: 0.1,
                    maxChildSize: 1,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: _selectedItems.length,
                          itemBuilder: (context, index) {
                            final selectedItem =
                                _selectedItems.elementAt(index);
                            return ListTile(
                              title: Text(p.basename(selectedItem)),
                              onTap: () {
                                // Handle tap on selected item
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        } else if (state is FileError) {
          return const Scaffold(
            body: Center(child: Text('Nenhum arquivo de áudio encontrado!')),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Permissão de acesso negada.'),
                  const Text(
                      'O Aplicativo precida da permissão do usuario para ler arquivos de audio.'),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
