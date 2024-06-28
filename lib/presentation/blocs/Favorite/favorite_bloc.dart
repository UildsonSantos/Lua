import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<AddFavoriteEvent>((event, emit) {
      if (state is FavoriteLoaded) {
        final updatedFavorites =
            List<String>.from((state as FavoriteLoaded).favorites)
              ..add(event.directory);
        emit(FavoriteLoaded(updatedFavorites));
      } else {
        emit(FavoriteLoaded([event.directory]));
      }
    });
  }
}
