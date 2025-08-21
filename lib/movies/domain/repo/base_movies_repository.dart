import 'package:dartz/dartz.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';
import 'package:movies_app_clean/movies/domain/usecase/get_movie_details_usecase.dart';

import '../../../core/errors/failure.dart';
import '../entities/movie_details.dart';

abstract class BaseMoviesRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> getTopRatedMovies();
  Future<Either<Failure, MovieDetails>> getMoviesDetails(GetMovieDetailsParameter parameters);
}
