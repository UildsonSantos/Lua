import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lua/core/utils/utils.dart';
import 'package:lua/data/models/models.dart';
import 'package:lua/data/sources/music_file_data_source.dart';
import 'package:lua/domain/repositories/repositories.dart';
import 'package:lua/presentation/blocs/blocs.dart';
import 'package:lua/presentation/widgets/widgets.dart';

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

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<SongBloc>(),
            child: PlayerWidget(song: song),
          ),
        ));

        // Inicie a reprodução da música
        context.read<SongBloc>().add(PlaySongEvent(song));
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
            ? ListView.builder(
                itemCount: _currentDirectoryContents.length,
                itemBuilder: (context, index) {
                  FileSystemEntity item = _currentDirectoryContents[index];
                  return ListTile(
                    title: Text(item.path.split('/').last),
                    onTap: () {
                      _handleFileSelection(item);
                    },
                    onLongPress: () {
                      // TODO: Implemente o que acontece quando um arquivo é selecionado com longo pressionar
                      // TODO: Isso pode incluir adicionar o arquivo ao playback ou selecionar o diretório
                    },
                  );
                },
              )
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
