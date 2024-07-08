import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/features/files_explorer/presentation/file_explorer_page.dart';
import 'package:lua/features/files_favorites/presentation/blocs/blocs.dart';
import 'package:lua/shared/data/models/directory_info.dart';
import 'package:lua/shared/presentation/widgets/folder_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isVerticalView = true;

  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(LoadFavoritesEvent());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleView() {
    setState(() {
      _isVerticalView = !_isVerticalView;
    });
  }

  void _navigateToFileExplorerPage(BuildContext context, String directoryPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FileExplorerPage(
                initialDirectory: directoryPath,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LUA',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isVerticalView ? Icons.view_list_sharp : Icons.grid_view_sharp,
              size: 25,
            ),
            onPressed: _toggleView,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 7.0),
            child: IconButton(
              icon: const Icon(
                Icons.more_vert,
                size: 25,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                if (state.favorites.isNotEmpty) {
                  return Column(
                    children: [
                      const ListTile(
                        title: Text(
                          'Favoritos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: screenHeight / 2,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _isVerticalView ? 2 : 1,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: _isVerticalView ? 7 : 2,
                            childAspectRatio: _isVerticalView ? 1.2 : 7,
                          ),
                          itemCount: state.favorites.length,
                          itemBuilder: (context, index) {
                            DirectoryInfo item = state.favorites[index];
                            return FolderWidget(
                              directoryInfo: item,
                              key: Key(item.path),
                              isVerticalView: _isVerticalView,
                              icon: Icons.folder,
                              onTap: () {
                                _navigateToFileExplorerPage(context, item.path);
                              },
                            );
                          },
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const ListTile(
              title: Text(
                'Armazenamento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = _isVerticalView ? 195.0 : double.infinity;
                final maxHeight = _isVerticalView ? 160.0 : 60.0;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                    child: SizedBox(
                      width: maxWidth,
                      height: maxHeight,
                      child: FolderWidget(
                        icon: Icons.storage,
                        directoryInfo: DirectoryInfo(
                          type: 'dir',
                          path: '/storage/emulated/0',
                          fileCount: 0,
                          folderCount: 0,
                          name: 'Memória Interna',
                        ),
                        isVerticalView: _isVerticalView,
                        onTap: () {
                          _navigateToFileExplorerPage(
                              context, '/storage/emulated/0');
                        },
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Pastas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            label: 'Mais',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
