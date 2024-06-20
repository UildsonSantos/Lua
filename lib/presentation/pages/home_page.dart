import 'package:flutter/material.dart';

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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border:
                        _isVerticalView ? Border.all(color: Colors.grey) : null,
                  ),
                  width: 200.0,
                  child: Column(
                    verticalDirection: VerticalDirection.down,
                    children: [
                      ListTile(
                        title: const Text('Movies'),
                        subtitle: const Row(
                          children: [
                            Text('25'),
                            Icon(Icons.folder_rounded),
                            SizedBox(width: 7),
                            Text('5'),
                            Icon(Icons.insert_drive_file_outlined),
                          ],
                        ),
                        trailing: const Icon(Icons.more_vert),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: ListTile(
                    leading: const Icon(Icons.folder),
                    title: const Text('Diretório Favorito 2'),
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: ListTile(
                    leading: const Icon(Icons.folder),
                    title: const Text('Diretório Favorito 3'),
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: ListTile(
                    leading: const Icon(Icons.folder),
                    title: const Text('Diretório Favorito 4'),
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: ListTile(
                    leading: const Icon(Icons.folder),
                    title: const Text('Diretório Favorito 5'),
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: ListTile(
                    leading: const Icon(Icons.folder),
                    title: const Text('Diretório Favorito 6'),
                    onTap: () {},
                  ),
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
            onTap: () {},
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
