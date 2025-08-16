import 'package:dartz/dartz.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';
import 'package:movies_app_clean/movies/domain/repo/base_movies_repository.dart';

import '../../../core/errors/failure.dart';

class GetPopularMoviesUseCase {
  final BaseMoviesRepository baseMoviesRepository;

  GetPopularMoviesUseCase(this.baseMoviesRepository);

  Future<Either<Failure, List<Movie>>> execute() async {
    return await baseMoviesRepository.getPopularMovies();
  }
}