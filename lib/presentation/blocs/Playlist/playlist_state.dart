part of 'playlist_bloc.dart';

sealed class PlaylistState extends Equatable {
  const PlaylistState();
  
  @override
  List<Object> get props => [];
}

final class PlaylistInitial extends PlaylistState {}
