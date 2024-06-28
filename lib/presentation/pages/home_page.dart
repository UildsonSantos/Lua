import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/presentation/blocs/blocs.dart';
import 'package:lua/presentation/pages/pages.dart';
import 'package:lua/presentation/widgets/widgets.dart';

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
    context.read<FileBloc>().add(RequestPermissionEvent());
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

  void _navigateToFileExplorerPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const FileExplorerPage(
                initialDirectory: '/storage/emulated/0',
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LUA'),
        actions: [
          IconButton(
            icon: Icon(
                _isVerticalView ? Icons.list_rounded : Icons.grid_view_rounded),
            onPressed: _toggleView,
          ),
        ],
      ),
      body: Column(
        children: [
          const ListTile(
            title: Text('Favoritos'),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _isVerticalView ? screenHeight / 6 : screenHeight / 2,
            ),
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                 if (state is FavoriteLoaded) {
                  return GridView.builder(
                    scrollDirection:
                        _isVerticalView ? Axis.horizontal : Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _isVerticalView ? 1 : 2,
                    ),
                    itemCount: state.favorites.length,
                    itemBuilder: (context, index) {
                      final directory = state.favorites[index];
                      return FolderWidget(
                        fileCount: 10,
                        folderCount: 7,
                        isVerticalView: _isVerticalView,
                        icon: Icons.folder,
                        fileOrDirectory: directory,
                        onAddFavorite: () {
                          context.read<FavoriteBloc>().add(AddFavoriteEvent(directory));
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Armazenamento'),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Memória Interna'),
            onTap: () {
              _navigateToFileExplorerPage(context);
            },
          ),
        ],
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
