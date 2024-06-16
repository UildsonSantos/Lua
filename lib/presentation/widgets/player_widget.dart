import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/presentation/blocs/blocs.dart';

class PlayerWidget extends StatefulWidget {
  final Playlist playlist;
  final int initialIndex;

  const PlayerWidget({
    super.key,
    required this.playlist,
    this.initialIndex = 0,
  });

  @override
  PlayerWidgetState createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    context
        .read<SongBloc>()
        .add(PlaySongEvent(widget.playlist.songs[currentIndex]));
  }

  void _playSong(int index) {
    final song = widget.playlist.songs[index];
    context.read<SongBloc>().add(PlaySongEvent(song));
    setState(() {
      currentIndex = index;
    });
  }

  void _playNextSong() {
    if (currentIndex < widget.playlist.songs.length - 1) {
      _playSong(currentIndex + 1);
    }
  }

  void _playPreviousSong() {
    if (currentIndex > 0) {
      _playSong(currentIndex - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.playlist.name),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.playlist.songs.length,
                  itemBuilder: (context, index) {
                    final song = widget.playlist.songs[index];
                    return ListTile(
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: _playPreviousSong,
                  ),
                  IconButton(
                    icon: Icon(
                      state is SongPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      if (state is SongPlaying) {
                        context.read<SongBloc>().add(PauseSongEvent());
                      } else if (widget.playlist.songs.isNotEmpty) {
                        _playSong(currentIndex);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: _playNextSong,
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
