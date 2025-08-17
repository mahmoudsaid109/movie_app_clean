import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_clean/core/utils/enums.dart';
import 'package:movies_app_clean/movies/presentation/controller/cubit/movies_events.dart';
import 'package:movies_app_clean/movies/presentation/controller/cubit/movies_state.dart';

import '../../../domain/usecase/get_now_playing_usecase.dart';

class MoviesBloc extends Bloc<MoviesEvents, MoviesState> {
  final GetNowPlayingUseCase getNowPlayingUseCase;
  MoviesBloc(this.getNowPlayingUseCase) : super(const MoviesState()) {
    on<GetNowPlayingMoviesEvent>((evnt, emit) async {
     
      final result = await getNowPlayingUseCase.execute();
      emit(const MoviesState(nowPlayingState: RequestState.loading));
      result.fold(
        (l) => {
          emit(
            MoviesState(
              nowPlayingState: RequestState.error,
              nowPlayingMessage: l.message,
            ),
          ),
        },
        (r) => {
          emit(
            MoviesState(
              nowPlayingState: RequestState.loaded,
              nowPlayingMovies: r,
            ),
          ),
        },
      );
    });
  }
}
