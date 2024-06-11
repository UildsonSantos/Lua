import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lua/core/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<FileSystemEntity> _currentDirectoryContents = [];
  final List<Directory> _directoryStack = [Directory('/storage/emulated/0')];
  final List<String> _directoryNames = ['Armazenamento interno'];

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
      print('Permissão negada.');
      PermissionApp.permissionRequest();
    }
  }

  Future<void> _loadDirectoryContents(Directory directory) async {
    List<FileSystemEntity> contents = await listFilesAndDirectories(directory);
    setState(() {
      _currentDirectoryContents = contents;
    });
  }

  Future<List<FileSystemEntity>> listFilesAndDirectories(
      Directory directory) async {
    List<FileSystemEntity> entities = [];
    if (directory.existsSync()) {
      await for (FileSystemEntity entity in directory.list()) {
        entities.add(entity);
      }
    }

    return entities;
  }

  void _handleFileSelection(FileSystemEntity fileOrDirectory) {
    if (fileOrDirectory is File) {
      //TODO: Implemente aqui o que acontece quando um arquivo de áudio é selecionado
      if (kDebugMode) {
        print('Arquivo de áudio selecionado: ${fileOrDirectory.path}');
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
                child: _currentDirectoryContents == null
                    ? const CircularProgressIndicator()
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Nenhum arquivo de áudio encontrado'),
                          ElevatedButton(
                            onPressed: () => _loadDirectoryContents(_directoryStack.last),
                            child: const Icon(Icons.refresh_rounded),
                          )
                        ],
                      ),
              ),
      ),
    );
  }
}
