import 'package:dartz/dartz.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';

import '../../../core/errors/failure.dart';

abstract class BaseMoviesRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> getTopRatedMovies();
}
