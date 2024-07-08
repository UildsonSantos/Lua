import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/features/files_favorites/presentation/blocs/blocs.dart';
import 'package:lua/shared/data/models/models.dart';

class FolderWidget extends StatelessWidget {
  final bool? isVerticalView;
  final IconData? icon;
  final DirectoryInfo directoryInfo;
  final VoidCallback? onTap;

  const FolderWidget({
    super.key,
    this.isVerticalView = false,
    this.icon,
    required this.directoryInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String title = '';
    if (directoryInfo.name != null) {
      title = directoryInfo.name!;
    } else {
      title = directoryInfo.path.split('/').last;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: isVerticalView! ? Border.all(color: Colors.grey) : null,
        ),
        child: isVerticalView!
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: directoryInfo.type == 'dir'
                          ? Icon(
                              icon ?? Icons.folder,
                              size: 70.0,
                            )
                          : Icon(
                              icon ?? Icons.audiotrack_rounded,
                              size: 70.0,
                            )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 19),
                              ),
                            ),
                            Row(
                              children: [
                                if (directoryInfo.folderCount > 0) ...[
                                  Text(
                                    '${directoryInfo.folderCount}',
                                  ),
                                  const Icon(
                                    Icons.folder_outlined,
                                    size: 25,
                                  ),
                                ],
                                if (directoryInfo.fileCount > 0 &&
                                    directoryInfo.folderCount > 0)
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
                                if (directoryInfo.fileCount > 0) ...[
                                  Text('${directoryInfo.fileCount}'),
                                  const Icon(
                                    Icons.insert_drive_file_outlined,
                                    size: 21,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        BlocBuilder<FavoriteBloc, FavoriteState>(
                          builder: (context, state) {
                            bool isFavorite =
                                state.favorites.contains(directoryInfo);

                            return PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'add') {
                                  context.read<FavoriteBloc>().add(
                                      AddFavoriteEvent(folder: directoryInfo));
                                } else if (value == 'remove') {
                                  context.read<FavoriteBloc>().add(
                                      RemoveFavoriteEvent(
                                          folder: directoryInfo));
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
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: directoryInfo.type == 'dir'
                          ? Icon(
                              icon ?? Icons.folder,
                              size: 60.0,
                            )
                          : Icon(
                              icon ?? Icons.audiotrack_rounded,
                              size: 60.0,
                            )),
                  const SizedBox(width: 14),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 260,
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (directoryInfo.folderCount > 0) ...[
                            Text('${directoryInfo.folderCount}'),
                            directoryInfo.type == 'dir'
                                ? const Icon(
                                    Icons.folder_outlined,
                                    size: 15.0,
                                  )
                                : const Icon(
                                    Icons.audiotrack_rounded,
                                    size: 30.0,
                                  )
                          ],
                          if (directoryInfo.fileCount > 0 &&
                              directoryInfo.folderCount > 0)
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
                          if (directoryInfo.fileCount > 0) ...[
                            Text('${directoryInfo.fileCount}'),
                            const Icon(Icons.insert_drive_file_outlined,
                                size: 13.0),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, state) {
                      bool isFavorite = state.favorites.contains(directoryInfo);

                      return PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'add') {
                            context
                                .read<FavoriteBloc>()
                                .add(AddFavoriteEvent(folder: directoryInfo));
                          } else if (value == 'remove') {
                            context.read<FavoriteBloc>().add(
                                RemoveFavoriteEvent(folder: directoryInfo));
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
                ],
              ),
      ),
    );
  }
}
