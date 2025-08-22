import 'package:dio/dio.dart';
import 'package:movies_app_clean/core/errors/exceptions.dart';
import 'package:movies_app_clean/core/network/api_constant.dart';
import 'package:movies_app_clean/movies/domain/usecase/get_movie_details_usecase.dart';

import '../../../../core/network/errors_message_model.dart';
import '../../../domain/usecase/get_recommendation_usecase.dart';
import '../../models/get_movie_details_model.dart';
import '../../models/movie_model.dart';
import '../../models/recommendation_model.dart';

// BaseMovieRemoteDataSource => is an abstract class that contains the methods(use cases) that we will use to get data from the remote data source
abstract class BaseMovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailsModel> getMoviesDetails(
    GetMovieDetailsParameter parameters,
  );
  Future<List<RecommendationModel>> getMovieRecommendations(
    RecommendationParameters parameter,
  );
}

class MovieRemoteDataSource extends BaseMovieRemoteDataSource {
  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await Dio().get(ApiConstance.nowPlayingMoviesPath);
    if (response.statusCode == 200) {
      return List<MovieModel>.from(
        (response.data['results'] as List).map((e) => MovieModel.fromJson(e)),
      );
    } else {
      // Server Exception class => from core/errors/exceptions.dart
      throw ServerException(
        errorsMessageModel: ErrorsMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await Dio().get(ApiConstance.popularMoviesPath);
    if (response.statusCode == 200) {
      return List<MovieModel>.from(
        (response.data['results'] as List).map((e) => MovieModel.fromJson(e)),
      );
    } else {
      // Server Exception class => from core/errors/exceptions.dart
      throw ServerException(
        errorsMessageModel: ErrorsMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await Dio().get(ApiConstance.topRatedMoviesPath);
    if (response.statusCode == 200) {
      return List<MovieModel>.from(
        (response.data['results'] as List).map((e) => MovieModel.fromJson(e)),
      );
    } else {
      // Server Exception class => from core/errors/exceptions.dart
      throw ServerException(
        errorsMessageModel: ErrorsMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<MovieDetailsModel> getMoviesDetails(
    GetMovieDetailsParameter parameters,
  ) async {
    final response = await Dio().get(
      ApiConstance.movieDetailsPath(parameters.movieId),
    );
    if (response.statusCode == 200) {
      return MovieDetailsModel.fromJson((response.data));
    } else {
      // Server Exception class => from core/errors/exceptions.dart
      throw ServerException(
        errorsMessageModel: ErrorsMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<RecommendationModel>> getMovieRecommendations(
    RecommendationParameters parameter,
  ) async {
    final response = await Dio().get(
      ApiConstance.movieDetailsPath(parameter.movieId),
    );
    if (response.statusCode == 200) {
      return List<RecommendationModel>.from(
        (response.data['results'] as List).map(
          (e) => RecommendationModel.fromJson(e),
        ),
      );
    } else {
      throw ServerException(
        errorsMessageModel: ErrorsMessageModel.fromJson(response.data),
      );
    }
  }
}
