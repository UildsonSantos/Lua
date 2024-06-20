import 'package:flutter/material.dart';

class FolderWidget extends StatelessWidget {
  final bool isVerticalView;
  final IconData icon;
  final String title;
  final int folderCount;
  final int fileCount;

  const FolderWidget({
    super.key,
    required this.isVerticalView,
    required this.icon,
    required this.title,
    required this.folderCount,
    required this.fileCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: isVerticalView ? Border.all(color: Colors.grey) : null,
        ),
        width: 200.0,
        child: isVerticalView
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
                        Text('$folderCount'),
                        const Icon(Icons.folder_rounded),
                        const SizedBox(width: 7),
                        Text('$fileCount'),
                        const Icon(Icons.insert_drive_file_outlined),
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
                          Text('$folderCount'),
                          const Icon(Icons.folder_rounded),
                          const SizedBox(width: 7),
                          Text('$fileCount'),
                          const Icon(Icons.insert_drive_file_outlined),
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
