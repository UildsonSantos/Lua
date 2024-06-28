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

    final List<Widget> favoritos = [
      FolderWidget(
        fileCount: 10,
        folderCount: 7,
        isVerticalView: _isVerticalView,
        icon: Icons.folder,
        fileOrDirectory: '/storage/emulated/0/Movies',
      ),
      FolderWidget(
        fileCount: 10,
        folderCount: 7,
        isVerticalView: _isVerticalView,
        icon: Icons.folder,
        fileOrDirectory: '/storage/emulated/0/Music',
      ),
      FolderWidget(
        fileCount: 10,
        folderCount: 7,
        isVerticalView: _isVerticalView,
        icon: Icons.folder,
        fileOrDirectory: '/storage/emulated/0/Documents',
      ),
      FolderWidget(
        fileCount: 10,
        folderCount: 7,
        isVerticalView: _isVerticalView,
        icon: Icons.folder,
        fileOrDirectory: '/storage/emulated/0/DCIM',
      ),
      FolderWidget(
        fileCount: 10,
        folderCount: 7,
        isVerticalView: _isVerticalView,
        icon: Icons.folder,
        fileOrDirectory: '/storage/emulated/0/Download',
      ),
      FolderWidget(
        fileCount: 10,
        folderCount: 7,
        isVerticalView: _isVerticalView,
        icon: Icons.folder,
        fileOrDirectory: '/storage/emulated/0/Picture',
      ),
      FolderWidget(
        fileCount: 10,
        folderCount: 7,
        isVerticalView: _isVerticalView,
        icon: Icons.folder,
        fileOrDirectory: '/storage/emulated/0/Recordings',
      ),
    ];

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
          Container(
            constraints: BoxConstraints(
              maxHeight: screenHeight / 2,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(7.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _isVerticalView ? 2 : 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: _isVerticalView ? 1 : 6,
              ),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                return favoritos[index];
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
