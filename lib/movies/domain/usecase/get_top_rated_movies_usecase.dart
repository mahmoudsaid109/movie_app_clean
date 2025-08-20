import 'package:dartz/dartz.dart';
import 'package:movies_app_clean/core/usecase/base_usecase.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';
import 'package:movies_app_clean/movies/domain/repo/base_movies_repository.dart';

import '../../../core/errors/failure.dart';

class GetTopRatedMoviesUseCase extends BaseUsecase<List<Movie>> {
  final BaseMoviesRepository baseMoviesRepository;

  GetTopRatedMoviesUseCase(this.baseMoviesRepository);
  @override
  Future<Either<Failure, List<Movie>>> call() async {
    return await baseMoviesRepository.getTopRatedMovies();
  }
}
