import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app_clean/core/errors/failure.dart';
import 'package:movies_app_clean/core/usecase/base_usecase.dart';
import 'package:movies_app_clean/movies/domain/entities/recommendation.dart';
import 'package:movies_app_clean/movies/domain/repo/base_movies_repository.dart';

class GetRecommendationUsecase
    extends BaseUsecase<List<Recommendation>, RecommendationParameters> {
  final BaseMoviesRepository baseMoviesRepository;
  GetRecommendationUsecase(this.baseMoviesRepository);
  @override
  Future<Either<Failure, List<Recommendation>>> call(
    RecommendationParameters parameter,
  ) async {
    return await baseMoviesRepository.getMovieRecommendations(parameter);
  }
}

class RecommendationParameters extends Equatable {
  final int movieId;
  const RecommendationParameters({required this.movieId});

  @override
  List<Object?> get props => [movieId];
}
