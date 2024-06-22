import 'dart:io';

import 'package:flutter/material.dart';

class FolderWidget extends StatelessWidget {
  final bool? isVerticalView;
  final IconData icon;
  final Directory fileOrDirectory;

  const FolderWidget({
    super.key,
    this.isVerticalView = false,
    required this.icon,
    required this.fileOrDirectory,
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
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar diretório');
        } else {
          int folderCount = snapshot.data?['folderCount'] ?? 0;
          int fileCount = snapshot.data?['fileCount'] ?? 0;

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
                          subtitle: Row(
                            children: [
                              folderCount > 0
                                  ? Text('$folderCount')
                                  : const SizedBox(),
                              folderCount > 0
                                  ? const Icon(Icons.folder_rounded)
                                  : const SizedBox(),
                              const SizedBox(width: 7),
                              fileCount > 0
                                  ? Text('$fileCount')
                                  : const SizedBox(),
                              fileCount > 0
                                  ? const Icon(Icons.insert_drive_file_outlined)
                                  : const SizedBox(),
                            ],
                          ),
                          trailing: const Icon(Icons.more_vert),
                          onTap: () {},
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
                              children: [
                                folderCount > 0
                                    ? Text('$folderCount')
                                    : const SizedBox(),
                                folderCount > 0
                                    ? const Icon(Icons.folder_rounded)
                                    : const SizedBox(),
                                const SizedBox(width: 7),
                                fileCount > 0
                                    ? Text('$fileCount')
                                    : const SizedBox(),
                                fileCount > 0
                                    ? const Icon(
                                        Icons.insert_drive_file_outlined)
                                    : const SizedBox(),
                              ],
                            ),
                            trailing: const Icon(Icons.more_vert),
                            onTap: () {},
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
