import 'dart:io';

import 'package:flutter/material.dart';

class FolderWidget extends StatelessWidget {
  final bool? isVerticalView;
  final IconData icon;
  final Directory fileOrDirectory;
  final VoidCallback? onTap;

  const FolderWidget({
    super.key,
    this.isVerticalView = false,
    required this.icon,
    required this.fileOrDirectory,
    this.onTap,
  });

  Future<Map<String, int>> counterFileOrDirectory(
      Directory fileOrDirectory) async {
    int folderCount = 0;
    int fileCount = 0;

    await for (FileSystemEntity entity in fileOrDirectory.list()) {
      if (entity is Directory) {
        folderCount++;
      } else if (entity is File) {
        fileCount++;
      }
    }

    return {'folderCount': folderCount, 'fileCount': fileCount};
  }

  @override
  Widget build(BuildContext context) {
    String title = fileOrDirectory.path.split('/').last;

    return FutureBuilder<Map<String, int>>(
      future: counterFileOrDirectory(fileOrDirectory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: isVerticalView! ? Border.all(color: Colors.grey) : null,
              ),
              width: 200.0,
              child: isVerticalView!
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 70,
                        ),
                        ListTile(
                          title: Text(title),
                          subtitle: const Row(
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                          trailing: const Icon(Icons.more_vert),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(icon, size: 60),
                        Expanded(
                          child: ListTile(
                            title: Text(title),
                            subtitle: const Row(
                              children: [
                                CircularProgressIndicator(),
                              ],
                            ),
                            trailing: const Icon(Icons.more_vert),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar diretório');
        } else {
          int folderCount = snapshot.data!['folderCount']!;
          int fileCount = snapshot.data!['fileCount']!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: isVerticalView! ? Border.all(color: Colors.grey) : null,
              ),
              width: 200.0,
              child: isVerticalView!
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(icon, size: 70),
                        ListTile(
                          title: Text(title),
                          subtitle: Row(
                            children: [
                              if (folderCount > 0) ...[
                                Text('$folderCount'),
                                const Icon(Icons.folder_outlined),
                              ],
                              const SizedBox(width: 7),
                              if (fileCount > 0) ...[
                                Text('$fileCount'),
                                const Icon(Icons.insert_drive_file_outlined),
                              ],
                            ],
                          ),
                          trailing: const Icon(Icons.more_vert),
                          onTap: onTap,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(icon, size: 60),
                        Expanded(
                          child: ListTile(
                            title: Text(title),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (folderCount > 0) ...[
                                  Text('$folderCount'),
                                  const Icon(Icons.folder_outlined, size: 15.0),
                                ],
                                if (fileCount > 0 && folderCount > 0)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 4.0),
                                    child: Text(
                                      '•',
                                      style: TextStyle(
                                          fontSize: 10.0,
                                          height: 0.75,
                                          color: Colors.grey),
                                    ),
                                  ),
                                if (fileCount > 0) ...[
                                  Text('$fileCount'),
                                  const Icon(Icons.insert_drive_file_outlined,
                                      size: 13.0),
                                ],
                              ],
                            ),
                            trailing: const Icon(Icons.more_vert),
                            onTap: onTap,
                          ),
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
