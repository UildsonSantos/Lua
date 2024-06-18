import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lua/application/services/services.dart';
import 'package:lua/domain/entities/entities.dart';
import 'package:lua/presentation/blocs/blocs.dart';

class PlayerWidget extends StatefulWidget {
  final Playlist playlist;
  final ScrollController scrollController;
  final int initialIndex;

  const PlayerWidget({
    super.key,
    required this.playlist,
    required this.scrollController,
    this.initialIndex = 0,
  });

  @override
  PlayerWidgetState createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget> {
  int currentIndex = 0;
  final MusicPlayerService _musicPlayerService =
      GetIt.instance<MusicPlayerService>();

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    _musicPlayerService.audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _musicPlayerService.audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration ?? Duration.zero;
      });
    });

    _musicPlayerService.audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _onSongComplete();
      }
    });

    _playSong(widget.initialIndex);
  }

  void _onSongComplete() {
    context.read<SongBloc>().add(SongCompleteEvent());
    _playNextSong();
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _seekToPosition(double seconds) {
    _musicPlayerService.audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        return Container(
          color: Colors.amber,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: widget.scrollController,
                  itemCount: widget.playlist.songs.length,
                  itemBuilder: (context, index) {
                    final song = widget.playlist.songs[index];
                    return ListTile(
                      title: Text(song.title),
                      subtitle: Text(_formatDuration(
                          Duration(milliseconds: song.duration))),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('  ${_formatDuration(_currentPosition)}'),
                      Text('${_formatDuration(_totalDuration)}    '),
                    ],
                  ),
                  Slider(
                    value: _currentPosition.inSeconds.toDouble(),
                    max: _totalDuration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _seekToPosition(value);
                    },
                  ),
                ],
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
                        state is SongPlaying ? Icons.pause : Icons.play_arrow),
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
