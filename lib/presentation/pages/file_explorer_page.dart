import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/domain/usecases/usecases.dart';
import 'package:lua/presentation/blocs/blocs.dart';
import 'package:lua/presentation/widgets/widgets.dart';

class FileExplorerPage extends StatelessWidget {
  const FileExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileBloc(
        loadDirectoryContents: GetIt.instance<LoadDirectoryContents>(),
        requestPermission: GetIt.instance<RequestPermission>(),
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
  final List<DirectoryModel> _directoryStack = [
    DirectoryModel(path: '/storage/emulated/0', fileCount: 0, folderCount: 0)
  ];
  final List<String> _directoryNames = ['Navigator'];
  bool _showButton = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
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
      context.read<FileBloc>().add(LoadDirectoryContentsEvent(
          _directoryStack[index],
          limit: 10,
          offset: 0));
    }
  }

  void _handleDirectoryModelSelection(DirectoryModel directoryModel) {
    setState(() {
      _directoryStack.add(DirectoryModel(
          fileCount: directoryModel.fileCount,
          folderCount: directoryModel.folderCount,
          path: directoryModel.path));
      _directoryNames.add(directoryModel.path.split('/').last);
    });
    context
        .read<FileBloc>()
        .add(LoadDirectoryContentsEvent(directoryModel, limit: 10, offset: 0));
  }

  void _handleFileSelection(FileModel file) {
    // Handle file selection logic here, if needed
    print('Selected file: ${file.path}');
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
                  itemCount:
                      contents.directories.length + contents.files.length,
                  itemBuilder: (context, index) {
                    final item = index < contents.directories.length
                        ? contents.directories[index]
                        : contents.files[index - contents.directories.length];

                    if (item is DirectoryModel) {
                      return FolderWidget(
                        icon: Icons.folder,
                        fileOrDirectory: item,
                        onTap: () => _handleDirectoryModelSelection(item),
                      );
                    } else if (item is FileModel) {
                      return ListTile(
                        leading: const Icon(Icons.audiotrack_rounded, size: 30),
                        title: Text(item.path),
                        onTap: () => _handleFileSelection(item),
                      );
                    } else {
                      return const SizedBox(); // Unexpected case
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
