import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final String _rootDirectoryPath = '/storage/emulated/0/Music';
  late List<FileSystemEntity> _currentDirectoryContents = [];

  @override
  void initState() {
    super.initState();
    _loadDirectoryContents(Directory(_rootDirectoryPath));
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
        if (entity is File || entity is Directory) {
          entities.add(entity);
        }
      }
    }

    return entities;
  }

  void _handleFileSelection(FileSystemEntity fileOrDirectory) {
    if (fileOrDirectory is File) {
      // Implemente aqui o que acontece quando um arquivo de áudio é selecionado
      if (kDebugMode) {
        print('Arquivo de áudio selecionado: ${fileOrDirectory.path}');
      }
      // Adicione o arquivo de áudio ao playback ou faça qualquer outra ação necessária
    } else if (fileOrDirectory is Directory) {
      // Se o item selecionado for um diretório, carregue os arquivos e diretórios dentro dele
      _loadDirectoryContents(fileOrDirectory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Músicas'),
      ),
      body: _currentDirectoryContents != null &&
              _currentDirectoryContents.isNotEmpty
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
                    // Implemente o que acontece quando um arquivo é selecionado com longo pressionar
                    // Isso pode incluir adicionar o arquivo ao playback ou selecionar o diretório
                  },
                );
              },
            )
          : Column(
              children: [
                Center(
                  child: _currentDirectoryContents == null
                      ? const CircularProgressIndicator()
                      : const Text('Nenhum arquivo de áudio encontrado'),
                ),
              ],
            ),
    );
  }
}
