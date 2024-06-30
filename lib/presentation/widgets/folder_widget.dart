import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/presentation/blocs/Favorite/favorite_bloc.dart';
import 'package:lua/presentation/blocs/blocs.dart';

class FolderWidget extends StatelessWidget {
  final bool? isVerticalView;
  final IconData icon;
  final String fileOrDirectory;
  final int folderCount;
  final int fileCount;
  final VoidCallback? onTap;

  const FolderWidget({
    super.key,
    this.isVerticalView = false,
    required this.icon,
    required this.fileOrDirectory,
    required this.folderCount,
    required this.fileCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String title = fileOrDirectory.split('/').last;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: isVerticalView! ? Border.all(color: Colors.grey) : null,
      ),
      child: isVerticalView!
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
                  child: Icon(
                    icon,
                    size: 70,
                  ),
                ),
                ListTile(
                  title: Text(title),
                  subtitle: Row(
                    children: [
                      if (folderCount > 0) ...[
                        Text('$folderCount'),
                        const Icon(Icons.folder_outlined),
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
                        const Icon(Icons.insert_drive_file_outlined),
                      ],
                    ],
                  ),
                  trailing: BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, state) {
                      bool isFavorite =
                          state.favorites.contains(fileOrDirectory);
                      return PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'add') {
                            context
                                .read<FavoriteBloc>()
                                .add(AddFavoriteEvent(fileOrDirectory));
                          } else if (value == 'remove') {
                            context.read<FavoriteBloc>().add(
                                RemoveFavoriteEvent(
                                    directory: fileOrDirectory));
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: isFavorite ? 'remove' : 'add',
                            child: Text(isFavorite
                                ? 'Remove from Favorites'
                                : 'Add to Favorites'),
                          ),
                        ],
                      );
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
                    trailing: BlocBuilder<FavoriteBloc, FavoriteState>(
                      builder: (context, state) {
                        bool isFavorite =
                            state.favorites.contains(fileOrDirectory);
                        return PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'add') {
                              context
                                  .read<FavoriteBloc>()
                                  .add(AddFavoriteEvent(fileOrDirectory));
                            } else if (value == 'remove') {
                              context.read<FavoriteBloc>().add(
                                  RemoveFavoriteEvent(
                                      directory: fileOrDirectory));
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              value: isFavorite ? 'remove' : 'add',
                              child: Text(isFavorite
                                  ? 'Remove from Favorites'
                                  : 'Add to Favorites'),
                            ),
                          ],
                        );
                      },
                    ),
                    onTap: onTap,
                  ),
                ),
              ],
            ),
    );
  }
}
