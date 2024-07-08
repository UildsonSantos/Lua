import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lua/features/files_explorer/data/dao/dao.dart';
import 'package:lua/features/files_explorer/domain/repositories/repositories.dart';
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
  Future<Map<String, List<dynamic>>> getDirectoryContents(
      String dirPath) async {
    return await _fileDAO.getFileOrDirectoryContents(dirPath);
  }

  @override
  Future<void> scanDirectoriesAndSaveToDatabase() async {
    await _fileDAO.clearDatabase();

    final root = Directory('/storage/emulated/0');

    final directory = {
      'path': root.path,
      'name': 'Memória Interna',
      'isFavorite': 0,
      'type': 'dir',
      'parent_id': null,
    };

    await _fileDAO.insertFileOrDirectory(directory);

    await _scanDirectory(root);
  }

  Future<void> _scanDirectory(Directory dir) async {
    if (await _requestPermission.call()) {
      try {
        final List<FileSystemEntity> entities = dir.listSync();
        for (var entity in entities) {
          if (entity is Directory &&
              !isAndroidDataDirectory(entity) &&
              !p.basename(entity.path).startsWith('.')) {
            final directory = {
              'path': entity.path,
              'name': p.basename(entity.path),
              'isFavorite': 0,
              'type': 'dir',
              'parent_id': p.dirname(entity.path),
            };
            await _fileDAO.insertFileOrDirectory(directory);

            await _scanDirectory(entity);
          } else if (entity is File && isMediaFile(entity)) {
            final file = {
              'path': entity.path,
              'name': p.basename(entity.path),
              'type': 'file',
              'parent_id': p.dirname(entity.path),
            };

            await _fileDAO.insertFileOrDirectory(file);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error scanning directory: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print(
            'Permissão de armazenamento negada. Não é possível escanear diretórios.');
      }
    }
  }
}
