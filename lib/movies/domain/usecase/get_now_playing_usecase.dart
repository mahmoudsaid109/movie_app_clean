import 'package:dartz/dartz.dart';
import 'package:movies_app_clean/movies/domain/entities/movie.dart';
import 'package:movies_app_clean/movies/domain/repo/base_movies_repository.dart';

import '../../../core/errors/failure.dart';

class GetNowPlayingUseCase {
  final BaseMoviesRepository baseMoviesRepository;

  GetNowPlayingUseCase(this.baseMoviesRepository);

    Future<Either<Failure, List<Movie>>> execute() async {
    return await baseMoviesRepository.getNowPlayingMovies();
  }
}
