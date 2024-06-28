import 'package:flutter/material.dart';

class FolderWidget extends StatelessWidget {
  final bool? isVerticalView;
  final IconData icon;
  final String fileOrDirectory;
  final int folderCount;
  final int fileCount;
  final VoidCallback? onTap;
  final VoidCallback? onAddFavorite;

  const FolderWidget({
    super.key,
    this.isVerticalView = false,
    required this.icon,
    required this.fileOrDirectory,
    required this.folderCount,
    required this.fileCount,
    this.onTap,
    this.onAddFavorite,
  });

  @override
  Widget build(BuildContext context) {
    String title = fileOrDirectory.split('/').last;

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
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'favorite',
                          child: Text('Add to Favorites'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'favorite' && onAddFavorite != null) {
                          onAddFavorite!();
                        }
                      },
                    ),
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
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'favorite',
                            child: Text('Add to Favorites'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'favorite' && onAddFavorite != null) {
                            onAddFavorite!();
                          }
                        },
                      ),
                      onTap: onTap,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
