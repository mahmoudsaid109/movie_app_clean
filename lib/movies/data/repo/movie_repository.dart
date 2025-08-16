import 'package:dartz/dartz.dart';
import 'package:movies_app_clean/core/errors/exceptions.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';

import '../../../core/errors/failure.dart';
import '../../domain/repo/base_movies_repository.dart';
import '../data_source/remote/movie_remote_data_source.dart';

class MovieRepository extends BaseMoviesRepository {
  final BaseMovieRemoteDataSource baseMovieRemoteDataSource;

  MovieRepository({required this.baseMovieRemoteDataSource});
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    final result = await baseMovieRemoteDataSource.getNowPlayingMovies();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorsMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    final result = await baseMovieRemoteDataSource.getPopularMovies();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorsMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async {
    final result = await baseMovieRemoteDataSource.getTopRatedMovies();
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorsMessageModel.statusMessage));
    }
  }
}
