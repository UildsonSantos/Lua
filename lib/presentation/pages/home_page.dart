import 'dart:io';

import 'package:flutter/material.dart';
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
      MaterialPageRoute(builder: (context) => const FileExplorerPage()),
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
            child: ListView(
              scrollDirection:
                  _isVerticalView ? Axis.horizontal : Axis.vertical,
              children: [
                FolderWidget(
                  isVerticalView: _isVerticalView,
                  icon: Icons.folder,
                  fileOrDirectory: Directory('/storage/emulated/0/Movies'),
                ),
                FolderWidget(
                  isVerticalView: _isVerticalView,
                  icon: Icons.folder,
                  fileOrDirectory: Directory('/storage/emulated/0/Music'),
                ),
                FolderWidget(
                  isVerticalView: _isVerticalView,
                  icon: Icons.folder,
                  fileOrDirectory: Directory('/storage/emulated/0/Documents'),
                ),
              ],
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
