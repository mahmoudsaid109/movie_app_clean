import 'package:dartz/dartz.dart';
import 'package:movies_app_clean/core/usecase/base_usecase.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';
import 'package:movies_app_clean/movies/domain/repo/base_movies_repository.dart';

import '../../../core/errors/failure.dart';

class GetPopularMoviesUseCase extends BaseUsecase<List<Movie>,NoParameters> {
  final BaseMoviesRepository baseMoviesRepository;

  GetPopularMoviesUseCase(this.baseMoviesRepository);
  @override
  Future<Either<Failure, List<Movie>>> call(NoParameters parameters) async {
    return await baseMoviesRepository.getPopularMovies();
  }
}
