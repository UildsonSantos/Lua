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

  void counterFileOrDirectory(
      int folderCount, int fileCount, Directory fileOrDirectory) async {
    await for (FileSystemEntity entity in fileOrDirectory.list()) {
      if (entity is Directory) {
        folderCount++;
      } else if (entity is File) {
        fileCount++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int folderCount = 0;
    int fileCount = 0;
    String title = fileOrDirectory.path.split('/').last;

    counterFileOrDirectory(folderCount, fileCount, fileOrDirectory);

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
                        folderCount > 0 ? Text('$folderCount') : const Spacer(),
                        folderCount > 0
                            ? const Icon(Icons.folder_rounded)
                            : const Spacer(),
                        const SizedBox(width: 7),
                        fileCount > 0 ? Text('$fileCount') : const Spacer(),
                        fileCount > 0
                            ? const Icon(Icons.insert_drive_file_outlined)
                            : const Spacer(),
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
                              : const Spacer(),
                          folderCount > 0
                              ? const Icon(Icons.folder_rounded)
                              : const Spacer(),
                          const SizedBox(width: 7),
                          fileCount > 0 ? Text('$fileCount') : const Spacer(),
                          fileCount > 0
                              ? const Icon(Icons.insert_drive_file_outlined)
                              : const Spacer(),
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
}
