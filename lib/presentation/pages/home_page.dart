import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/core/utils/utils.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/data/sources/music_file_data_source.dart';
import 'package:lua/domain/repositories/repositories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<FileSystemEntity> _currentDirectoryContents = [];
  final List<Directory> _directoryStack = [Directory('/storage/emulated/0')];
  final List<String> _directoryNames = ['Armazenamento interno'];
  final FileRepository _fileRepository = GetIt.instance<FileRepository>();
  final MusicFileDataSource _musicFileDataSource = MusicFileDataSource();
  final Set<FileSystemEntity> _selectedSongs = {};
  final List<SongModel> _addedSongs = [];

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadContent();
  }

  Future<void> _requestPermissionAndLoadContent() async {
    bool hasPermission = await PermissionApp.permissionRequest();
    if (hasPermission) {
      _loadDirectoryContents(_directoryStack.last);
    } else {
      if (kDebugMode) {
        print('Permissão negada.');
      }
      PermissionApp.permissionRequest();
    }
  }

  Future<void> _loadDirectoryContents(Directory directory) async {
    List<FileSystemEntity> contents =
        await _fileRepository.listFilesAndDirectories(directory);
    setState(() {
      _currentDirectoryContents = contents;
    });
  }

  void _handleFileSelection(FileSystemEntity fileOrDirectory) async {
    if (fileOrDirectory is File) {
      if (fileOrDirectory.path.endsWith('.mp3') ||
          fileOrDirectory.path.endsWith('.mp4')) {
        SongModel song =
            await _musicFileDataSource.getSingleLocalSong(fileOrDirectory.path);

        setState(() {
          _selectedSongs.add(fileOrDirectory);
          _addedSongs.add(song);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Arquivo não suportado: ${fileOrDirectory.path.split('/').last}')),
        );
      }
    } else if (fileOrDirectory is Directory) {
      setState(() {
        _directoryStack.add(fileOrDirectory);
        _directoryNames.add(fileOrDirectory.path.split('/').last);
      });
      _loadDirectoryContents(fileOrDirectory);
    }
  }

  void _onPopInvoked(bool popWasInvoked) {
    if (!popWasInvoked && _directoryStack.isNotEmpty) {
      _navigateToPreviousDirectory();
    } else {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).maybePop();
      }
    }
  }

  void _navigateToPreviousDirectory() {
    if (_directoryStack.length > 1) {
      setState(() {
        _directoryStack.removeLast();
        _directoryNames.removeLast();
      });
      _loadDirectoryContents(_directoryStack.last);
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => _onPopInvoked(didPop),
      canPop:
          false, // Impede que o botão de voltar do sistema faça o pop da tela

      child: Scaffold(
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
        body: _currentDirectoryContents.isNotEmpty
            ? Stack(children: [
                ListView.builder(
                  itemCount: _currentDirectoryContents.length,
                  itemBuilder: (context, index) {
                    final fileOrDirectory = _currentDirectoryContents[index];
                    final isSelected = _selectedSongs.contains(fileOrDirectory);
                    return InkWell(
                      child: Container(
                        color: isSelected
                            ? Colors.deepPurpleAccent
                            : Colors.transparent,
                        child: ListTile(
                          title: Text(fileOrDirectory.path.split('/').last),
                          onTap: () {
                            if (isSelected) {
                              setState(() {
                                _selectedSongs.remove(fileOrDirectory);
                              });
                            } else {
                              _handleFileSelection(fileOrDirectory);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),

                // DraggableScrollableSheet
                DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  minChildSize: 0.15,
                  maxChildSize: 0.9,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: IconButton(
                              iconSize: 60,
                              padding: const EdgeInsets.only(bottom: 200.0),
                              color: Colors.purple,
                              icon: const Icon(
                                Icons.play_circle_rounded,
                              ),
                              onPressed: () {
                                setState(() {
                                  // _addedSongs.addAll(null);
                                  _selectedSongs.clear();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      body: Container(
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: _addedSongs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(_addedSongs[index].artist),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ])
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Nenhum arquivo de áudio encontrado'),
                    ElevatedButton(
                      onPressed: () =>
                          _loadDirectoryContents(_directoryStack.last),
                      child: const Icon(Icons.refresh_rounded),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
