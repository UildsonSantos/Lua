import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/presentation/blocs/blocs.dart';

class PlayerWidget extends StatelessWidget {
  final Playlist playlist;

  const PlayerWidget({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(playlist.name),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: playlist.songs.length,
                  itemBuilder: (context, index) {
                    final song = playlist.songs[index];
                    return ListTile(
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                    );
                  },
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      state is SongPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      if (state is SongPlaying) {
                        context.read<SongBloc>().add(PauseSongEvent());
                      } else if (playlist.songs.isNotEmpty) {
                        context
                            .read<SongBloc>()
                            .add(PlaySongEvent(playlist.songs[0]));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
