import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LUA'),
      ),
      body: const Column(
        children: [
          ListTile(
            title: Text('Favoritos'),
          ),
          ListTile(
            title: Text('Armazenamento'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Pasta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Lista de Reprodução',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            label: 'Mais',
          ),
        ],
      ),
    );
  }
}
