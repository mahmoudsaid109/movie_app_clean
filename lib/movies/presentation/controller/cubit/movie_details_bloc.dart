import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_clean/core/utils/enums.dart';
import 'package:movies_app_clean/movies/domain/usecase/get_movie_details_usecase.dart';
import 'package:movies_app_clean/movies/domain/usecase/get_recommendation_usecase.dart';
import 'movie_details_state.dart';
part 'movie_details_event.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc(this.getMovieDetailsUseCase, this.getRecommendationUseCase)
    : super(const MovieDetailsState()) {
    on<GetMovieDetailsEvent>(_getMovieDetails);
    on<GetMovieRecommendationEvent>(_getRecommendation);
  }
  final GetMovieDetailsUseCase getMovieDetailsUseCase;
  final GetRecommendationUsecase getRecommendationUseCase;
  FutureOr<void> _getMovieDetails(
    GetMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    final result = await getMovieDetailsUseCase(
      GetMovieDetailsParameter(movieId: event.movieId),
    );
    result.fold(
      (l) => emit(
        state.copyWith(
          movieDetailsState: RequestState.error,
          movieDetailsMessage: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(movieDetails: r, movieDetailsState: RequestState.loaded),
      ),
    );
  }

 FutureOr<void> _getRecommendation(GetMovieRecommendationEvent event,
      Emitter<MovieDetailsState> emit) async {
    final result = await getRecommendationUseCase(
      RecommendationParameters(
         movieId: event.movieId,
      ),
    );

    result.fold(
      (l) => emit(state.copyWith(
        recommendationsState: RequestState.error,
        recommendationsMessage: l.message,
      )),
      (r) => emit(
        state.copyWith(
          recommendations: r,
          recommendationsState: RequestState.loaded,
        ),
      ),
    );
  }
}