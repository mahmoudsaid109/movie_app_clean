import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app_clean/core/errors/failure.dart';
import 'package:movies_app_clean/core/usecase/base_usecase.dart';
import 'package:movies_app_clean/movies/domain/entities/movie_details.dart';
import 'package:movies_app_clean/movies/domain/repo/base_movies_repository.dart';

class GetMovieDetailsUseCase extends BaseUsecase<MovieDetails, GetMovieDetailsParameter> {
  final BaseMoviesRepository baseMoviesRepository;
  GetMovieDetailsUseCase(this.baseMoviesRepository);

  @override
  Future<Either<Failure, MovieDetails>> call(GetMovieDetailsParameter parameters) async {
    return await baseMoviesRepository.getMoviesDetails();
  }
}

class GetMovieDetailsParameter extends Equatable {
  final int movieId;
  const GetMovieDetailsParameter({required this.movieId});
  @override
  List<Object?> get props => [movieId];
}
