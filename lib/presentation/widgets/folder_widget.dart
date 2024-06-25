
import 'package:flutter/material.dart';
import 'package:lua/data/models/directory_models.dart';

class FolderWidget extends StatelessWidget {
  final bool? isVerticalView;
  final IconData icon;
  final DirectoryModel fileOrDirectory;
 
  final VoidCallback? onTap;

  const FolderWidget({
    super.key,
    this.isVerticalView = false,
    required this.icon,
    required this.fileOrDirectory,
    
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String title = fileOrDirectory.path.split('/').last;

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
                        if (fileOrDirectory.folderCount > 0) ...[
                          Text('${fileOrDirectory.folderCount}'),
                          const Icon(Icons.folder_outlined),
                        ],
                        const SizedBox(width: 7),
                        if (fileOrDirectory.fileCount > 0) ...[
                          Text('${fileOrDirectory.fileCount}'),
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
                           if (fileOrDirectory.folderCount > 0) ...[
                          Text('${fileOrDirectory.folderCount}'),
                            const Icon(Icons.folder_outlined, size: 15.0),
                          ],
                          if (fileOrDirectory.fileCount > 0 && fileOrDirectory.folderCount > 0)
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
                          if (fileOrDirectory.fileCount > 0) ...[
                          Text('${fileOrDirectory.fileCount}'),
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
}
