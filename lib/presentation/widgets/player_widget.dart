import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lua/domain/entities/song.dart';
import 'package:lua/presentation/blocs/blocs.dart';

class PlayerWidget extends StatelessWidget {
  final Song song;

  const PlayerWidget({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(song.title),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Playing: ${song.title}'),
              IconButton(
                icon: Icon(
                  state is SongPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  if (state is SongPlaying) {
                    context.read<SongBloc>().add(PauseSongEvent());
                  } else {
                    context.read<SongBloc>().add(PlaySongEvent(song));
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () {
                  context.read<SongBloc>().add(StopSongEvent());
                },
              ),
              // Adicione aqui outros botões e indicadores de progresso
            ],
          ),
        );
      },
    );
  }
}
