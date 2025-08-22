import 'package:dartz/dartz.dart';
import 'package:movies_app_clean/core/errors/failure.dart';
import 'package:movies_app_clean/movies/domain/entities/movie_details.dart';
import 'package:movies_app_clean/movies/domain/entities/recommendation.dart';
import 'package:movies_app_clean/movies/domain/usecase/get_movie_details_usecase.dart';
import 'package:movies_app_clean/movies/domain/usecase/get_recommendation_usecase.dart';

import '../../../core/errors/exceptions.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repo/base_movies_repository.dart';
import '../data_source/remote/movie_remote_data_source.dart';


class MoviesRepository extends BaseMoviesRepository {
  final BaseMovieRemoteDataSource baseMovieRemoteDataSource;

  MoviesRepository(this.baseMovieRemoteDataSource);

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

  @override
  Future<Either<Failure, MovieDetails>> getMoviesDetails(
      GetMovieDetailsParameter parameters) async {
    final result = await baseMovieRemoteDataSource.getMovieDetails(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorsMessageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getMovieRecommendations(
      RecommendationParameters parameters) async {
    final result =
        await baseMovieRemoteDataSource.getRecommendation(parameters);
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorsMessageModel.statusMessage));
    }
  }
}