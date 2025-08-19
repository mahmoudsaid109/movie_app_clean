import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_clean/core/utils/enums.dart';
import 'package:movies_app_clean/movies/presentation/controller/cubit/movies_events.dart';
import 'package:movies_app_clean/movies/presentation/controller/cubit/movies_state.dart';

import '../../../domain/usecase/get_now_playing_usecase.dart';
import '../../../domain/usecase/get_popular_movies_usecase.dart';
import '../../../domain/usecase/get_top_rated_movies_usecase.dart';

class MoviesBloc extends Bloc<MoviesEvents, MoviesState> {
  final GetNowPlayingMoviesUseCase getNowPlayingUseCase;
  final GetPopularMoviesUseCase getPopularMoviesUseCase;
  final GetTopRatedMoviesUseCase getTopRatedMoviesUseCase;
  MoviesBloc(
    this.getNowPlayingUseCase,
    this.getPopularMoviesUseCase,
    this.getTopRatedMoviesUseCase,
  ) : super(const MoviesState()) {
    on<GetNowPlayingMoviesEvent>((evnt, emit) async {
      final result = await getNowPlayingUseCase.execute();
      // emit(const MoviesState(nowPlayingState: RequestState.loading));
      result.fold(
        (l) => {
          emit(
            state.copyWith(
              nowPlayingState: RequestState.error,
              nowPlayingMessage: l.message,
            ),
          ),
        },
        (r) => {
          emit(
            state.copyWith(
              nowPlayingState: RequestState.loaded,
              nowPlayingMovies: r,
            ),
          ),
        },
      );
    });
    on<GetPopularMoviesEvent>((evnt, emit) async {
      final result = await getPopularMoviesUseCase.execute();
      // emit(const MoviesState(popularState: RequestState.loading));
      result.fold(
        (l) => {
          emit(
            state.copyWith(
              popularState: RequestState.error,
              popularMessage: l.message,
            ),
          ),
        },
        (r) => {
          emit(
            state.copyWith(popularState: RequestState.loaded, popularMovies: r),
          ),
        },
      );
    });
  }
}
