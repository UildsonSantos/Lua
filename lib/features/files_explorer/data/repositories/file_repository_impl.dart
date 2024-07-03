import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lua/features/files_explorer/data/dao/dao.dart';
import 'package:lua/features/files_explorer/domain/repositories/repositories.dart';
import 'package:lua/shared/data/models/models.dart';
import 'package:lua/shared/domain/usecases/usecases.dart';
import 'package:path/path.dart' as p;

class FileRepositoryImpl implements FileRepository {
  final RequestPermission _requestPermission;
  final FileDAO _fileDAO;

  FileRepositoryImpl(this._requestPermission, this._fileDAO);

  bool isAndroidDataDirectory(Directory directory) {
    return directory.path.contains('/Android/');
  }

  bool isMediaFile(File file) {
    String extension = p.extension(file.path).toLowerCase();
    return extension == '.mp3' || extension == '.mp4';
  }

  @override
  Future<Map<String, int>> countFilesAndDirectories(Directory directory) async {
    if (await _requestPermission.execute()) {
      int fileCount = 0;
      int dirCount = 0;

      await for (var entity
          in directory.list(recursive: false, followLinks: false)) {
        if (entity is Directory &&
            !entity.path.split('/').last.startsWith('.') &&
            isAndroidDataDirectory(entity)) {
          continue;
        }

        if (entity is File) {
          fileCount++;
        } else if (entity is Directory) {
          dirCount++;
        }
      }

      return {'files': fileCount, 'directories': dirCount};
    } else {
      //TODO: Tratar o caso de permissão negada
      return {};
    }
  }

  @override
Future<Map<String, List<dynamic>>> listDirectoriesAndFiles(String dirPath) async {
  if (await _requestPermission.execute()) {
    var mainDirectory = Directory(dirPath);
    List<DirectoryInfo> subDirectories = [];
    List<File> mediaFiles = [];

    if (!(await mainDirectory.exists())) {
      if (kDebugMode) {
        print('O diretório não existe.');
      }
      return {'directories': subDirectories, 'files': mediaFiles};
    }

    // Obter os diretórios do banco de dados
    List<DirectoryInfo> existingDirectories = await _fileDAO.getAllDirectories();

    // Verificar quais diretórios precisam ser adicionados ao banco de dados
    List<DirectoryInfo> newDirectories = [];
    await for (var entity in mainDirectory.list(recursive: false, followLinks: false)) {
      if (entity is Directory && !isAndroidDataDirectory(entity)) {
        var result = await countFilesAndDirectories(entity);
        DirectoryInfo info = DirectoryInfo(
          path: entity.path,
          fileCount: result['files']!,
          folderCount: result['directories']!,
        );

        if (!existingDirectories.any((d) => d.path == info.path)) {
          newDirectories.add(info);
        } else {
          // Atualizar a informação do diretório existente
          int index = existingDirectories.indexWhere((d) => d.path == info.path);
          existingDirectories[index] = info;
        }
      } else if (entity is File && isMediaFile(entity)) {
        mediaFiles.add(entity);
      }
    }

    // Salvar os novos diretórios no banco de dados
    await _fileDAO.saveDirectories(newDirectories);

    // Retornar a lista de diretórios (existentes e novos) e arquivos
    List<DirectoryInfo> allDirectories = [...existingDirectories, ...newDirectories];
    return {'directories': allDirectories, 'files': mediaFiles};
  } else {
    //TODO: Tratar o caso de permissão negada
    return {};
  }
}

}
