import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final String _directoryPath = '/storage/emulated/0/Music';
  late List<FileSystemEntity> _dirAaudioFiles = [];

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  Future<void> _loadAudioFiles() async {
    final directory = Directory(_directoryPath);
    List<FileSystemEntity> dirFiles = await listFilesAndDirectories(directory);
    setState(() {
      _dirAaudioFiles = dirFiles;
    });
  }

  Future<List<FileSystemEntity>> listFilesAndDirectories(
      Directory directory) async {
    List<FileSystemEntity> entities = [];

    if (directory.existsSync()) {
      await for (FileSystemEntity entity in directory.list()) {
        if (entity is File || entity is Directory) {
          entities.add(entity);
          if (entity is Directory) {
            List<FileSystemEntity> subDirectoryEntities =
                await listFilesAndDirectories(entity);
            entities.addAll(subDirectoryEntities);
          }
        }
      }
    }

    return entities;
  }

  void _handleFileSelection(FileSystemEntity file) {
    //TODO: Implemente aqui o que acontece quando um arquivo de áudio é selecionado
    if (kDebugMode) {
      print('Arquivo de áudio selecionado: ${file.path}');
    }
    //TODO: Adicione o arquivo de áudio ao playback ou faça qualquer outra ação necessária
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Músicas'),
      ),
      body: _dirAaudioFiles != null && _dirAaudioFiles.isNotEmpty
          ? ListView.builder(
              itemCount: _dirAaudioFiles.length,
              itemBuilder: (context, index) {
                FileSystemEntity file = _dirAaudioFiles[index];
                return ListTile(
                  title: Text(file.path.split('/').last),
                  onTap: () {
                    _handleFileSelection(file);
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
                  child: _dirAaudioFiles != null ?
                       const CircularProgressIndicator() // Show CircularProgressIndicator if _dirAaudioFiles is null
                      : const Text('Nenhum arquivo de áudio encontrado'),
                ),
                Text(_dirAaudioFiles.toString())
              ],
            ),
    );
  }
}
